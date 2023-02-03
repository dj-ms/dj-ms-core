import datetime
import uuid

from django.conf import settings
from django.utils import timezone
from rest_framework.authentication import TokenAuthentication
from rest_framework.exceptions import AuthenticationFailed

from authentication.models import Token


TOKEN_TTL = settings.REST_AUTH_TOKEN_TTL


def generate_token(user):
    user_id = user.pk
    Token.objects.filter(user_id=user_id, active=True).update(active=False)
    key = uuid.uuid4()
    token = Token.objects.create(key=key, user_id=user_id, active=True)
    return token.key


class ExpiringTokenAuthentication(TokenAuthentication):
    model = Token
    keyword = 'Bearer'

    def authenticate_credentials(self, key, request=None):
        try:
            token = self.model.objects.get(key=key)
        except self.model.DoesNotExist:
            raise AuthenticationFailed({"error": "Invalid or Inactive Token", "is_authenticated": False})
        else:
            if not token.user.is_active:
                raise AuthenticationFailed({"error": "Invalid user", "is_authenticated": False})
            if not token.active:
                raise AuthenticationFailed({"error": "Inactive Token", "is_authenticated": False})
            now = timezone.now()
            diff = now - datetime.timedelta(seconds=TOKEN_TTL)
            if token.last_use < diff:
                token.active = False
                token.save()
                raise AuthenticationFailed({"error": "Token has expired", "token_status": False})
        token.last_use = now
        token.save()
        return token.user, token
