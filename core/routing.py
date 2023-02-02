from channels.routing import URLRouter
from django.urls import re_path

from app.ws.routing import websocket_urlpatterns as app_websocket_urlpatterns
from core.consumers import AsyncHealthCheckConsumer


websocket_urlpatterns = [
    re_path(r'ws/health', AsyncHealthCheckConsumer.as_asgi()),
    re_path(r'ws/', URLRouter(app_websocket_urlpatterns)),
]
