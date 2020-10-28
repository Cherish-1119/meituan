from django.urls import path
from rest_framework.routers import DefaultRouter
from apps.h5 import views

router = DefaultRouter(trailing_slash=False)
# 商家管理
router.register('merchant', views.MerchantViewSet, basename='merchant')
# 地址管理
router.register('address', views.AddressViewSet, basename='address')

app_name = 'smscode'
urlpatterns = [
                  # 登录的短信验证
                  path('smscode', views.SMSCodeView.as_view(), name='smscode'),
                  # 登录
                  path('login', views.LoginView.as_view(), name='login'),
                  # 搜索
                  path('search', views.MerchantSearchView.as_view(), name='search'),
                  # 对应商家下的商品分类
                  path('category/merchant/<int:merchant_id>', views.CategoryView.as_view(), name='category'),
                  # 提交订单
                  path('submitorder', views.CreateOrderView.as_view(), name='submitorder'),
                  # 支付回调
                  path('callback', views.AlipayCallbackView.as_view(), name='callback'),
              ] + router.urls
