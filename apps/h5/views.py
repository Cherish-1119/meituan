import os
import random

from alipay import AliPay
from django.conf import settings
from django.contrib.auth import get_user_model
from django.core.cache import cache
from django.shortcuts import redirect
from django.utils.timezone import now
from rest_framework import views, status, viewsets, mixins, generics, filters

from rest_framework.decorators import action
from rest_framework.pagination import PageNumberPagination
from rest_framework.permissions import IsAuthenticated

from apps.h5.serializers import LoginSerializer
from apps.h5.throttles import SMSCodeRateThrottle
from apps.meituan.models import Merchant, UserAddress, Goods, Order, GoodsCategory
from apps.meituan.serializers import MerchantSerializer, AddressSerializer, CreateOrderSerializer, \
    GoodsCategorySerializer
from apps.mtauth.authentications import generate_jwt, JWTAuthentication
from apps.mtauth.serializers import UserSerializer
from utils.CCPSDK import CCPRestSDK
from rest_framework.response import Response

User = get_user_model()


class SMSCodeView(views.APIView):
    # 手机短信验证码
    # 移动端还需要设置一个短信验证码登录后跳转设置密码的页面进行设置密码？或者是后台也用短信验证码进行登录
    # 短信验证码发送的节流限速
    throttle_classes = [SMSCodeRateThrottle]

    def __init__(self, *args, **kwargs):
        super(SMSCodeView, self).__init__(*args, **kwargs)
        # 构造函数从numbers中取出字符串组成随机的验证码，不用每次生成验证码都从服务器拿，
        # 可以在构造函数中存取一次保存在缓存中，后续在缓存中拿numbers
        self.numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

    def generate_sms_code(self):
        # 生成随机6位数的验证码
        return ''.join(random.choices(self.numbers, k=6))

    def get(self, request):
        # 要跟前端进行商量字段
        # /smscode?tel=xxxxx
        # 搜索链接：http://127.0.0.1:8000/smscode?tel=18584565981
        telephone = request.GET.get('tel')
        if telephone:
            accountSid = '8aaf0708732220a60173528af5381495'
            accountToken = 'd61c8f46ac5842a4bb4ef4325fe744e3'
            appId = '8aaf0708732220a60173528af605149b'
            rest = CCPRestSDK.REST(accountSid, accountToken, appId)
            # code = "%d" % (random.randint(100000, 999999))
            code = self.generate_sms_code()
            # 短信验证码的记忆缓存，过期时间5分钟
            print(code)
            cache.set(telephone, code, 60 * 5)
            # 验证码及过期时间5分钟，处于短信发送中的提示信息内容传递的参数，
            # 实际还需要设置cache及过期时间
            result = rest.sendTemplateSMS(telephone, [code, 5], '1')
            print(result)
            # 'statusCode'等于6个0的情况下，才是短信发送成功的[容联云进行发送的代码]
            if result['statusCode'] == '000000':
                return Response()
            else:
                # 500是内部服务器错误
                return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        else:
            # 400是参数错误
            return Response(status=status.HTTP_400_BAD_REQUEST)


class LoginView(views.APIView):
    # 移动端的登录视图--前后端需要交流的
    def generate_number(self):
        numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
        return ''.join(random.choices(numbers, k=6))

    def post(self, request):
        # 搜索链接：http://127.0.0.1:8000/login
        serializer = LoginSerializer(data=request.data)
        # 验证序列化数据的有效性
        if serializer.is_valid():
            telephone = serializer.validated_data.get('telephone')
            try:
                # get方法提取数据，只会返回第一条满足要求的数据；
                # 这里是获取到user对象，而不是queryset对象
                user = User.objects.get(telephone=telephone)
                user.last_login = now()
                user.save()
            # 捕获异常
            except:
                # 用户创建时，系统自动生成随机的用户名
                username = 'mtyhu' + self.generate_number()
                # 手机验证码登录的，密码设置为空
                password = ''
                # 这里还差默认的用户头像的获取？avatar?
                user = User.objects.create(username=username, password=password, telephone=telephone, last_login=now())

            serializer = UserSerializer(user)
            token = generate_jwt(user)
            return Response({'user': serializer.data, 'token': token})
        else:
            # errors不是返回真正的字典，而是返回的是ReturnDict，这里就需要进行字典格式化错误
            return Response(data={'message': dict(serializer.errors)}, status=status.HTTP_400_BAD_REQUEST)


class MerchantPagination(PageNumberPagination):
    # 商家列表分页
    # /merchant?page=1
    page_query_param = 'page'
    page_size = 8


class MerchantViewSet(
    viewsets.GenericViewSet,
    mixins.ListModelMixin,
    mixins.RetrieveModelMixin,
):
    # 商家列表视图集，视图集都是优先继承ViewSetMixin类，再继承一个视图类（GenericAPIView或APIView）
    # 这里继承的是GenericViewSet
    queryset = Merchant.objects.all()
    serializer_class = MerchantSerializer
    pagination_class = MerchantPagination


class MerchantSearchView(generics.ListAPIView):
    # 商家搜索视图
    class MerchantSearchFilter(filters.SearchFilter):
        # 查询结果返回的是一个列表集，就不再是单独的一个结果显示
        # 搜索链接：http://127.0.0.1:8000/search?q=麦当劳
        search_param = 'q'

    queryset = Merchant.objects.all()
    serializer_class = MerchantSerializer
    filter_backends = [MerchantSearchFilter]
    # 搜索字段按照商家的名称(Merchant)进行搜索,商品分类(GoodsCategory)所属商家下的名字搜索，
    # 商家商品（Goods）下的名字就像查找
    search_fields = ['name', 'categories__name', 'categories__goods_list__name']


class CategoryView(views.APIView):
    # 商家下面的商品分类视图--只需要查询分类下的数据
    def get(self, request, merchant_id=None):
        categories = GoodsCategory.objects.filter(merchant=merchant_id)
        serializer = GoodsCategorySerializer(categories, many=True)
        return Response(serializer.data)


class AddressViewSet(viewsets.ModelViewSet):
    # 继承了GenericAPIView方法，将对应的东西进行重写了
    # 这是返回数据库中所有的地址数据
    # queryset = UserAddress.objects.all()
    serializer_class = AddressSerializer
    # authentication_classes:用来验证用户是否已经成功登陆
    # authentication_classes = [JWTAuthentication]
    # permission_classes：用来根据用户的权限来限制访问
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # 这是返回对应用户下的地址数据
        return self.request.user.addresses.all()

    def perform_create(self, serializer):
        # 获取到地址里面的属性is_default
        is_default = serializer.validated_data.get('is_default')
        # 判断新增的地址是否为默认的用户地址
        if is_default:
            # 是的话，其它的地址的is_default更改为False，就更新为不是默认的地址
            self.request.user.addresses.update(is_default=False)
        # 保存对应的用户信息
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        is_default = serializer.validated_data.get('is_default')
        # 判断新增的地址是否为默认的用户地址
        if is_default:
            # 是的话，其它的地址的is_default更改为False，就更新为不是默认的地址
            self.request.user.addresses.update(is_default=False)
        # 保存对应的地址更改信息
        serializer.save()

    # /address/default
    # detail是否需要传递地址的ID进来，但是我们需要传递的是地址的列表，即为False
    @action(['GET'], detail=False, url_path='default')
    def default_address(self, request):
        # 获取到用户提交订单时设置的默认地址
        try:
            address = self.request.user.addresses.get(is_default=True)
        except:
            # 没有获取到用户默认地址下，获取用户地址库下第一条地址数据
            address = self.request.user.addresses.first()

        serializer = self.serializer_class(address)
        return Response(serializer.data)


class CreateOrderView(views.APIView):
    # 创建订单视图
    def post(self, request):
        serializer = CreateOrderSerializer(data=request.data)
        if serializer.is_valid():
            address_id = serializer.validated_data.get('address_id')
            goods_id_list = serializer.validated_data.get('goods_id_list')
            address = UserAddress.objects.get(pk=address_id)
            goods_list = Goods.objects.filter(pk__in=goods_id_list)
            goods_count = 0
            total_price = 0
            for goods in goods_list:
                goods_count += 1
                total_price += goods.price

            # order_id，pay_method，order_status都有默认的选择项，不用传递对应的参数进来
            order = Order.objects.create(
                address=address,
                goods_count=goods_count,
                total_price=total_price,
                user=request.user,
            )
            # 订单和购买的商品列表是多对多的关系，多对多关系需要用set赋予相应的权限
            order.goods_list.set(goods_list)
            order.save()

            # https: // github.com / fzlee / alipay / blob / master / README.zh - hans.md python-alipay-sdk
            app_private_key_string = open(os.path.join(settings.BASE_DIR, 'keys', 'app_private_key.txt'), 'r').read()
            alipay_public_key_string = open(os.path.join(settings.BASE_DIR, 'keys', 'alipay_public_key.txt'),
                                            'r').read()
            alipay = AliPay(
                appid="2016102300741978",
                app_notify_url=None,  # 默认回调url
                app_private_key_string=app_private_key_string,
                # 支付宝的公钥，验证支付宝回传消息使用，不是你自己的公钥,
                alipay_public_key_string=alipay_public_key_string,
                sign_type="RSA2",  # RSA 或者 RSA2
                debug=True,  # 默认False,沙箱环境为True
            )
            # 手机网站支付，需要跳转到:
            # 正式环境：https://openapi.alipay.com/gateway.do? + order_string
            # 沙箱环境：https://openapi.alipaydev.com/gateway.do? + order_string
            order_string = alipay.api_alipay_trade_wap_pay(
                out_trade_no=order.pk,
                # 要变更为字符串的形式，否则识别不了。TypeError: Object of type 'Decimal' is not JSON serializable
                total_amount=str(order.total_price),
                # 商品的名字，将订单商品名字归类或者取易懂的名字
                subject='测试支付商品',
                # 以下两个链接需要项目部署到云服务器后才会有对应的url
                # 支付成功后返回的页面
                # return_url=None,
                # 支付回调的是服务器的地址
                return_url="http://106.52.40.163:8000/callback",
                # 通知商户钱款到账的页面
                # notify_url=None,  # 可选, 不填则使用默认notify url
                notify_url="http://106.52.40.163:8000/callback",  # 可选, 不填则使用默认notify url
            )
            pay_url = 'https://openapi.alipaydev.com/gateway.do?' + order_string
            return Response({'pay_url': pay_url})
        else:
            return Response({'message': dict(serializer.errors)}, status=status.HTTP_400_BAD_REQUEST)


# 支付回调url,项目部署到服务器时进行更新支付回调的补充
class AlipayCallbackView(views.APIView):
    def get(self, request):
        # 回调到APP首页中
        return redirect("/")

    def post(self, request):
        data = request.data
        # 这里获取到的data并不是真正的字典的格式，需要进行转换
        alipay_data = {}
        for key, value in data.items():
            alipay_data[key] = value
        # 在校验支付时，会将对应的签名进行拿掉
        sign = alipay_data.pop("sign")
        app_private_key_string = open(os.path.join(settings.BASE_DIR, 'keys', 'app_private_key.txt'), 'r').read()
        alipay_public_key_string = open(os.path.join(settings.BASE_DIR, 'keys', 'alipay_public_key.txt'),
                                        'r').read()
        alipay = AliPay(
            appid="2016102300741978",
            app_notify_url=None,  # 默认回调url
            app_private_key_string=app_private_key_string,
            # 支付宝的公钥，验证支付宝回传消息使用，不是你自己的公钥,
            alipay_public_key_string=alipay_public_key_string,
            sign_type="RSA2",  # RSA 或者 RSA2
            debug=True,  # 默认False,沙箱环境为True
        )
        success = alipay.verify(alipay_data, sign)
        # 交易成功的处理方式
        if success and alipay_data["trade_status"] in ("TRADE_SUCCESS", "TRADE_FINISHED"):
            order_id = alipay_data.get('out_trade_no')
            order = Order.objects.get(pk=order_id)
            # 订单状态为待评价
            order.order_status = 4
            # 支付方式为支付宝支付
            order.pay_method = 2
            order.save()
            return Response()
        else:
            return Response({"message": "订单支付失败！"}, status=status.HTTP_400_BAD_REQUEST)
