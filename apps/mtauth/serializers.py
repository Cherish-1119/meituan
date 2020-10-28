from django.contrib.auth.models import Group
from rest_framework.serializers import ModelSerializer
from .models import MTUser


class GroupSerializer(ModelSerializer):
    #原本的展示只有id的展示
    class Meta:
        model = Group
        fields = ['id', 'name']


class UserSerializer(ModelSerializer):
    # 决定返回数据的格式，
    # 原有的前端返回只返回group的ID，现在返回的是ID和name
    # user和group是多对多的关系，所以就有many=true这个关系
    groups = GroupSerializer(many=True)

    class Meta:
        # 这里默认分组和用户是多对多的关系
        model = MTUser
        exclude = ['password']
