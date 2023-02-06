from django.urls import path

from authentication.api.views.auth_views import login_view, logout_view, register_view

urlpatterns = [
    path('login', login_view, name='login'),
    path('logout', logout_view, name='logout'),
    path('register', register_view, name='register')
]
