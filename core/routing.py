from channels.routing import URLRouter
from django.urls import path

from app import routing as app_routing

root_router = URLRouter([
    path('ws/', app_routing),
])
