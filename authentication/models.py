from auditlog.registry import auditlog
from django.contrib.auth.base_user import BaseUserManager, AbstractBaseUser
from django.contrib.auth.models import PermissionsMixin
from django.db import models
from rest_framework.authtoken.models import Token as AuthToken
from django.utils.translation import gettext_lazy as _


class MyUserManager(BaseUserManager):
    def create_user(self, username, first_name=None, last_name=None, password=None):
        user = self.model(
            username=username,
            first_name=first_name,
            last_name=last_name)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, password, first_name=None, last_name=None):
        user = self.create_user(password=password,
                                username=username,
                                first_name=first_name,
                                last_name=last_name)
        user.is_superuser = True
        user.is_staff = True
        user.save(using=self._db)
        return user


class User(AbstractBaseUser, PermissionsMixin):
    username = models.CharField(max_length=24, null=False, blank=False, unique=True)
    email = models.EmailField(unique=True, default=None, null=True)
    first_name = models.CharField(max_length=32, null=True, default=None)
    last_name = models.CharField(max_length=32, null=True, default=None)
    date_of_birth = models.DateField(null=True, default=None)
    date_joined = models.DateField(null=True, default=None)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = MyUserManager()

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = []

    def has_module_perms(self, app_label):
        """Does the user have permissions to view the app `app_label`?"""
        # Simplest possible answer: Yes, always
        return True

    class Meta:
        verbose_name = _('user')
        verbose_name_plural = _('users')
        db_table = 'auth_user'


class Token(AuthToken):
    key = models.CharField(_('Key'), max_length=40, primary_key=True)
    user_id = models.PositiveBigIntegerField(_('User'), db_index=True)
    created = models.DateTimeField(_('Created'), auto_now_add=True)
    last_use = models.DateTimeField(_('Last use'), auto_now=True)
    active = models.BooleanField(default=False)

    class Meta:
        verbose_name = _('Token')
        verbose_name_plural = _('Tokens')

    def __str__(self):
        return self.key

    @property
    def user(self):
        try:
            return User.objects.get(id=self.user_id)
        except User.DoesNotExist:
            self.delete()
            return None


auditlog.register(User)
