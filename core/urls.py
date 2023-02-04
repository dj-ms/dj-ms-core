"""dj_ms_core URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
import logging

from django.contrib import admin
from django.shortcuts import redirect
from django.urls import path, include

from core.settings import APP_LABEL


urlpatterns = [
    path(APP_LABEL + '/admin/', admin.site.urls),
    path(APP_LABEL + '/api/', include('app.api.urls'), name='api'),
    path(APP_LABEL, include('app.urls')),
    path(APP_LABEL + '/api/auth/', include('authentication.api.urls'), name='authentication'),
]


def get_redirect_url():
    try:
        return redirect(f'{APP_LABEL}')
    except Exception as e:
        logging.error(e)
        return redirect(f'{APP_LABEL}/admin')


urlpatterns += [
    path('', lambda req: get_redirect_url()),
]
