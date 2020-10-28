from django.urls import path
# from .views import LoginView, MerchantViewSet
from . import views
from rest_framework.routers import DefaultRouter

app_name = 'cms'
# 设置默认的路径
router = DefaultRouter(trailing_slash=False)
# trailing_slash=False的作用就是后面不用进行添加斜杠
# router.register('merchant',MerchantViewSet,basename='merchant')
# /cms/merchant
# 商家管理
router.register('merchant', views.MerchantViewSet, basename='merchant')
# cms/category
# 分类管理：商家下的商品--有疑问的？商品的分类--外键关联商家，商品本身的分类又关联商品的分类
router.register('category', views.CategoryViewSet, basename='category')
# cms/goods
# 商品管理
router.register('goods', views.GoodsViewSet, basename='goods')

# 以后关于商家的处理必须经过登录后才可以访问处理
urlpatterns = [
                  # 用户登录
                  path('login', views.LoginView.as_view(), name='login'),
                  # 上传图片
                  path('upload', views.PictureUploadView.as_view(), name='upload'),

              ] + router.urls
