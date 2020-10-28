from django.contrib.auth.models import Permission, Group
from django.contrib.contenttypes.models import ContentType
from django.core.management import BaseCommand

from apps.meituan.models import Merchant, GoodsCategory, Goods, Order


class Command(BaseCommand):
    # 分组创建的操作和权限的赋予
    def handle(self, *args, **options):
        # 1.编辑组
        edit_content_types = [
            ContentType.objects.get_for_model(Merchant),
            ContentType.objects.get_for_model(GoodsCategory),
            ContentType.objects.get_for_model(Goods),
        ]
        edit_permissions = Permission.objects.filter(content_type__in=edit_content_types)
        edit_group = Group.objects.create(name='编辑')
        edit_group.permissions.set(edit_permissions)
        edit_group.save()
        self.stdout.write('编辑组创建成功！')

        # 2.财务组
        finance_content_types = [
            ContentType.objects.get_for_model(Order),
        ]
        finance_permissions = Permission.objects.filter(content_type__in=finance_content_types)
        finance_group = Group.objects.create(name='财务')
        finance_group.permissions.set(finance_permissions)
        finance_group.save()
        self.stdout.write('财务组创建成功！')

        # 3.管理组
        # queryset对象不支持直接的相加‘+’的操作，这里采用的union;
        # 列表数据支持相加的操作'+'
        admin_permissions = edit_permissions.union(finance_permissions)
        admin_group = Group.objects.create(name='管理')
        admin_group.permissions.set(admin_permissions)
        admin_group.save()
        self.stdout.write('管理组创建成功！')
