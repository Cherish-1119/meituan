from rest_framework.permissions import BasePermission


# 扩展permissions.IsAdminUser里面只有is_staff的权限，
# 补充赋予超级管理员或者拥有这个权限的用户都可以操作
class IsEditorUser(BasePermission):
    def has_permission(self, request, view):
        # 'meituan.change_merchant'：数据库名字.对应的权限
        if request.user.is_superuser or request.user.has_perm('meituan.change_merchant'):
            return True
        else:
            return False


class IsFinanceUser(BasePermission):
    def has_permission(self, request, view):
        if request.user.is_superuser or request.user.has_perm('meituan.change_order'):
            return True
        else:
            return False
