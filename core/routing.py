from channels.routing import URLRouter
from django.urls import re_path

from app.routing import websocket_urlpatterns as app_websocket_urlpatterns


websocket_urlpatterns = [
    re_path(r'ws/', URLRouter(app_websocket_urlpatterns)),
]
