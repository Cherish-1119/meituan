import jwt
import time
from django.conf import settings
from django.contrib.auth import get_user_model
from jwt import ExpiredSignatureError
from rest_framework import exceptions
from rest_framework.authentication import get_authorization_header, BaseAuthentication

MTUser = get_user_model()


def generate_jwt(user):
    # 生成token
    # 过期时间是24个小时,time转换为整数秒
    expire_time = int(time.time()) + 60 * 60 * 24
    # jwt.encode将对应的数据进行编码为字节串bytes类型发送给服务端--生成token
    # return是要将服务器端的数据返回给客户端，就需要进行解码为字符串string类型，即jwt.encode().decode()，views.py对应使用的地方就不需要decode了
    # 三个参数：第一个是payload，是一个Json对象，主要用来存放有效的信息，例如用户名，过期时间等等所有你想要传递的信息；
            # 第二个是密钥，这里是读取配置文件中的SECRET_KEY配置变量，这个秘钥主要用在下文Signature签名中，服务端用来校验Token合法性，
            # 这个秘钥只有服务端知道，不能泄露；
            # 第三个是生成Token的算法。
    # key = settings.SECRET_KEY  # 这个可以自定义密钥，为了方便直接使用Django的密钥
    return jwt.encode({"userid": user.pk, "exp": expire_time}, key=settings.SECRET_KEY, algorithm='HS256').decode(
        'utf-8')


class JWTAuthentication(BaseAuthentication):
    #如何去验证token给与授权，重写了‘BaseAuthentication’这个方法其中的TokenAuthentication
    # Authorization: JWT eyJhbGciOiAiSFMyNTYiLCAidHlwIj
    keyword = 'JWT'

    def authenticate(self, request):
        auth = get_authorization_header(request).split()

        # auth[0]为jwt的头
        if not auth or auth[0].lower() != self.keyword.lower().encode():
            return None

        if len(auth) == 1:
            msg = "不可用的JWT请求头！"
            raise exceptions.AuthenticationFailed(msg)
        elif len(auth) > 2:
            msg = '不可用的JWT请求头！JWT Token中间不应该有空格！'
            raise exceptions.AuthenticationFailed(msg)

        try:
            # auth[1]为加密后的token
            token = auth[1]
            # 解密token,获取到playload中的信息拿到userID
            playload = jwt.decode(token, key=settings.SECRET_KEY, algorithm='HS256')
            userid = playload.get('userid')
            try:
                # 绑定当前user到request对象上
                user = MTUser.objects.get(pk=userid)
                # 以下两个的返回的结果都是可以的，能够正常运行
                return (user, token)
                # return (user, token.decode())
            except:
                msg = '用户不存在！'
                raise exceptions.AuthenticationFailed(msg)
        except ExpiredSignatureError:
            msg = "JWT Token已过期！"
            raise exceptions.AuthenticationFailed(msg)
