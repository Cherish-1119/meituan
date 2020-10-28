from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
from shortuuidfield import ShortUUIDField


class UserManager(BaseUserManager):
    #自定义创建用户时调用的方法
    def _create_user(self, telephone, username, password, **kwargs):
        if not telephone:
            raise ValueError('请传入手机号码！')
        if not username:
            raise ValueError('请传入用户名！')
        if not password:
            raise ValueError('请传入密码！')

        user = self.model(telephone=telephone, username=username, **kwargs)
        user.set_password(password)
        user.save()
        return user

    def create_user(self, telephone, username, password, **kwargs):
        kwargs['is_superuser'] = False
        return self._create_user(telephone, username, password, **kwargs)

    def create_superuser(self, telephone, username, password, **kwargs):
        kwargs['is_superuser'] = True
        kwargs['is_staff'] = True
        return self._create_user(telephone, username, password, **kwargs)


class MTUser(AbstractBaseUser, PermissionsMixin):
    """
    重写django自带的User表
    """
    uid = ShortUUIDField(primary_key=True, verbose_name="用户表主键")
    telephone = models.CharField(unique=True, max_length=11, verbose_name="手机号码")
    email = models.EmailField(unique=True, max_length=100, verbose_name='邮箱', null=True)
    #用户自己不写用户名，就系统自动生成一个用户名
    username = models.CharField(max_length=100, verbose_name="用户名", unique=False)
    avatar = models.CharField(max_length=200, verbose_name='头像链接')
    date_joined = models.DateTimeField(auto_now_add=True, verbose_name='加入时间')
    is_active = models.BooleanField(default=True, verbose_name="是否可用")
    is_staff = models.BooleanField(default=False, verbose_name="是否是员工")
    is_merchant = models.BooleanField(default=False, verbose_name="是否是商家")

    # 使用手机号码作为唯一验证的手段，不定义默认使用username
    USERNAME_FIELD = 'telephone'
    # 用于创建超级用户时需要输入的字段,实际就会要求输入REQUIRED_FIELDS和USERNAME_FIELD字段及password
    REQUIRED_FIELDS = ['username']
    # 用于给指定的用户发送邮件
    EMALL_FIELD = 'email'

    objects = UserManager()

    def get_full_name(self):
        return self.username

    def get_short_name(self):
        return self.username
