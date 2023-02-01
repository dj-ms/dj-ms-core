import logging

from django.db import connections
from django.http import HttpResponse, HttpResponseServerError


class HealthCheckMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.path == '/health':
            db_conn = connections['risk_db']
            try:
                _ = db_conn.cursor()
            except Exception as e:
                logging.error(e)
                return HttpResponseServerError('error')
            else:
                return HttpResponse('ok')
        return self.get_response(request)
