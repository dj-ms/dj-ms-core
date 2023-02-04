from channels.routing import URLRouter
from django.urls import re_path

from app.ws.routing import websocket_urlpatterns as app_websocket_urlpatterns
from core.consumers import AsyncHealthCheckConsumer
from core.settings import APP_LABEL

URL_PREFIX = APP_LABEL + '/' if APP_LABEL else ''

websocket_urlpatterns = [
    re_path(URL_PREFIX + 'ws/health', AsyncHealthCheckConsumer.as_asgi()),
    re_path(URL_PREFIX + 'ws/', URLRouter(app_websocket_urlpatterns)),
]
