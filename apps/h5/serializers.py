from rest_framework import serializers
from django.core.cache import cache


class LoginSerializer(serializers.Serializer):
    # 序列化不继承任何的model模型，就继承Serializer，自己进行定义
    telephone = serializers.CharField(max_length=11, min_length=11)
    smscode = serializers.CharField(max_length=6, min_length=6)

    def vaildate(self, attrs):
        # 验证短信验证码的有效性,内部字段的验证,前端是tel
        telephone = attrs.get('telephone')
        smscode = attrs.get('smscode')
        cache_code = cache.get(telephone)
        if cache_code != smscode:
            raise serializers.ValidationError('短信验证码错误！')
        return attrs
