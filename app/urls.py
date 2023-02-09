from django.shortcuts import redirect
from django.urls import path

from core.urls import URL_PREFIX

urlpatterns = [

]

# This redirects to the API root if there is no other root URL
if not any(url == '' for url in urlpatterns):
    urlpatterns += [
        path('', lambda req: redirect('/api/' + URL_PREFIX)),
    ]
