from rest_framework import throttling


class SMSCodeRateThrottle(throttling.SimpleRateThrottle):
    # 短信验证码发送节流的设置
    scope = 'smscode'

    def get_cache_key(self, request, view):
        # 通过tel进行传递参数’telephone‘
        telephone = request.GET.get('tel')
        #如果不是telephone验证成功的，没有传参就用对应的Ip地址传参
        if telephone:
            ident = telephone
        else:
            #不加的话默认使用的是匿名用户
            ident = self.get_ident(request)

        return self.cache_format % {
            'scope': self.scope,
            'ident': ident,
        }
