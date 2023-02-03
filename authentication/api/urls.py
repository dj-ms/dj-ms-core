from django.urls import path

from authentication.api.views.auth_views import login, logout, register

urlpatterns = [
    path('login', login, name='login'),
    path('logout', logout, name='logout'),
    path('register', register, name='register')
]
