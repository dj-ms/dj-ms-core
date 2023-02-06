import datetime
import logging

from django.contrib.auth import authenticate, password_validation, login, logout
from django.core.exceptions import ValidationError
from django.http import HttpResponse
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from authentication.models import User, Token
from django.utils.translation import gettext_lazy as _
from django.conf import settings


TOKEN_TTL = settings.REST_AUTH_TOKEN_TTL


@csrf_exempt
@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    username = request.data.get('username')
    password = request.data.get('password')
    if None in (username, password):
        return Response(status=status.HTTP_400_BAD_REQUEST)
    user_exists = User.objects.filter(username=username).exists()
    if not user_exists:
        return Response(status=status.HTTP_404_NOT_FOUND)
    user = authenticate(request, username=username, password=password)
    if user is None:
        return Response(status=status.HTTP_403_FORBIDDEN)
    now = timezone.now()
    diff = now - datetime.timedelta(seconds=TOKEN_TTL)
    token, created = Token.objects.get_or_create(user_id=user.pk, last_use__gt=diff, active=True)
    login(request, user)
    return Response({'token': token.key,
                     'user': {
                        'id': user.pk,
                        'username': user.username,
                        'email': user.email,
                        'first_name': user.first_name,
                        'last_name': user.last_name,
                     }})


@csrf_exempt
@api_view(['POST'])
def logout_view(request):
    if request.user.is_anonymous:
        return Response(status=status.HTTP_401_UNAUTHORIZED)
    user = request.user
    Token.objects.filter(user_id=user.pk).update(active=False)
    logout(request)
    return Response(status=status.HTTP_200_OK)


@csrf_exempt
@api_view(['POST'])
@permission_classes([AllowAny])
def register_view(request):
    username = request.POST.get('username')
    email = request.POST.get('email')
    password1 = request.POST.get('password1')
    password2 = request.POST.get('password2')
    first_name = request.POST.get('first_name')
    if None in [username, password1, password2]:
        return Response(status=status.HTTP_400_BAD_REQUEST)
    if password1 != password2:
        return HttpResponse(_('Passwords does not match'), status=status.HTTP_400_BAD_REQUEST)
    try:
        password_validation.validate_password(password1)
    except ValidationError as error:
        logging.error(error)
        return HttpResponse(status=status.HTTP_403_FORBIDDEN)
    if email:
        email_exists = User.objects.filter(email=email).exists()
        if email_exists:
            return HttpResponse(_('User with that email is already registered'), status=status.HTTP_403_FORBIDDEN)
    username_exists = User.objects.filter(username=username).exists()
    if username_exists:
        return HttpResponse(_('User with that username is already registered'), status=status.HTTP_403_FORBIDDEN)
    last_name = request.POST.get('last_name')
    new_user = User(
        username=username,
        email=email,
        first_name=first_name,
        last_name=last_name,
        is_active=True
    )
    new_user.set_password(password1)
    new_user.save()
    return Response(status=status.HTTP_201_CREATED)

