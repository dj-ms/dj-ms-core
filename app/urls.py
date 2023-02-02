from django.urls import path, include


urlpatterns = [
    path('api/', include('app.api.urls'), name='api'),
]
