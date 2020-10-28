import os

import shortuuid
from django.conf import settings
from django.utils.timezone import now
from rest_framework import viewsets, permissions, mixins, status
from rest_framework.authtoken.serializers import AuthTokenSerializer
from rest_framework.decorators import action
from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.meituan.models import Merchant, GoodsCategory, Goods
from apps.meituan.serializers import MerchantSerializer, GoodsCategorySerializer, GoodsSerializer
from apps.mtauth.authentications import generate_jwt, JWTAuthentication
from apps.mtauth.serializers import UserSerializer
from apps.mtauth.permissions import IsEditorUser, IsFinanceUser


class LoginView(APIView):
    def post(self, request):
        # 用序列化验证数据的有效性
        serializer = AuthTokenSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.validated_data.get('user')
            # 将用户此次的登录记录为上次登录的时间，清醒时间（settings配置了中国的时间）
            user.last_login = now()
            # 保存用户上次登录的时间
            user.save()
            # 进行token验证授权登录
            token = generate_jwt(user)
            # 将对应的orm模型数据类序列化为json字符串传递给前端渲染
            user_serializer = UserSerializer(user)
            return Response({'token': token, 'user': user_serializer.data})
        else:
            return Response({'message': '用户名或密码错误！'})


class MerchantPagination(PageNumberPagination):
    # 分页功能参数的配置
    # 一页展示8条数据
    page_size = 8
    page_query_param = 'page'


class CmsBaseView(object):
    # CMS后台管理系统的权限的设置
    # 针对的是用来管理某个对象的访问权限
    permission_classes = [permissions.IsAuthenticated, permissions.IsAdminUser]


# 继承的类放到前面才可以有对应的数据进去反馈给继承的子类
class MerchantViewSet(viewsets.ModelViewSet):
    # 商家发布的视图级的设置
    queryset = Merchant.objects.order_by('-create_time').all()
    # 序列化类
    serializer_class = MerchantSerializer
    # 权限的设置：必须登录及超级管理员的权限
    # permission_classes = [permissions.IsAuthenticated,permissions.IsAdminUser]
    # 授权的设置：token的验证--settings.py中已配置
    # authentication_classes = [JWTAuthentication]
    # 指定分页类:实现分页的效果
    pagination_class = MerchantPagination
    # 加入对应授权登录和编辑的权限，与CmsBaseView权限重复了，就不用继承这个类
    # from apps.mtauth.permissions import IsEditorUser
    permission_classes = [permissions.IsAuthenticated, IsEditorUser]


# 具备的功能：create、update、destroy（删除）、retrieve（检索数据-查-返回列表数据）分类的功能
# 商品分类视图集
class CategoryViewSet(
    # 登录权限的功能
    CmsBaseView,
    # register注册功能
    viewsets.GenericViewSet,
    # 组件继承相应的功能
    mixins.CreateModelMixin,
    mixins.UpdateModelMixin,
    mixins.DestroyModelMixin,
    mixins.RetrieveModelMixin,
):
    queryset = GoodsCategory.objects.all()
    serializer_class = GoodsCategorySerializer
    permission_classes = [permissions.IsAuthenticated, IsEditorUser]

    # 对destroy方法进行重写--对后端也进行同样的限制，分类下还有商品时，不能进行删除分类
    #原有的destroy方法是直接就进行删除了，不管分类下是否还有商品
    def destroy(self, request, *args, **kwargs):
        # get_object(self)：用于在数据检索的时候，返回一条数据的
        instance = self.get_object()
        # 商品列表的个数大于0，说明删除是不成功的，报400错误--无法操作成功删除
        # Goods模型中外键category的related_name='goods_list'
        if instance.goods_list.count() > 0:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            # perform_destroy(self,serializer)：删除对象的时候调用。
            self.perform_destroy(instance)
            # 204错误：请求执行成功，但是没有数据，浏览器不用刷新页面.也不用导向新的页面，删除成功的提示
            # 提交到服务器处理的数据，只需要返回是否成功的情况--返回是否删除成功
            return Response(status=status.HTTP_204_NO_CONTENT)

    # detail是否需要传递分类的主键进来在url中，不需要即为False
    # 获取到的url形式：/cms/category/merchant/<int:merchant_id>
    @action(['GET'], detail=False, url_path='merchant/(?P<merchant_id>\d+)')
    def merchant_category(self, request, merchant_id=None):
        # 根据商家的ID获取到分类
        # 获取到单个商家所属的分类，并序列化数据返回前端
        queryset = self.get_queryset()
        serializer_class = self.get_serializer_class()
        # 这里的感觉像是商家下有很多的分类？？？
        categories = queryset.filter(merchant=merchant_id)
        serializer = serializer_class(categories, many=True)
        return Response(serializer.data)


# 商品视图集
class GoodsViewSet(
    # 登录权限的功能
    CmsBaseView,
    # register注册功能
    viewsets.GenericViewSet,
    # 组件继承相应的功能
    mixins.CreateModelMixin,
    mixins.UpdateModelMixin,
    mixins.DestroyModelMixin,
    mixins.RetrieveModelMixin,
):
    queryset = Goods.objects.all()
    serializer_class = GoodsSerializer
    permission_classes = [permissions.IsAuthenticated, IsEditorUser]


class PictureUploadView(CmsBaseView, APIView):
    # 图片上传功能
    # permission_classes = [permissions.IsAuthenticated,permissions.IsAdminUser]
    def save_file(self, file):
        # 保存文件
        # 前端上传图片后的结果是一个元组，取扩展名就要取最后一个象
        # 肯德基.jpg=('肯德基','.jpg')
        # 生成自定义的名字不能重复（文件名）+文件的后缀名（文件的格式）
        filename = shortuuid.uuid() + os.path.splitext(file.name)[-1]
        # 图片的完整路径
        filepath = os.path.join(settings.MEDIA_ROOT, filename)
        with open(filepath, 'wb')as fp:
            # 将文件切成一段段减少服务器缓存的压力
            for chunk in file.chunks():
                fp.write(chunk)
        # /media/abc.jpg,只能获取到一段的路径
        # settings.MEDIA_URL+filename
        # 返回完整的文件的路径url(http://.../media/abc.jpg)
        return self.request.build_absolute_uri(settings.MEDIA_URL + filename)

    def post(self, request):
        # 根据前端来定的get的别名，此前端Upload组件默认是file,获取要与前端协商
        file = request.data.get('file')
        file_url = self.save_file(file)
        return Response({'picture': file_url})
