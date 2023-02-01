# Gunicorn configuration file
# https://docs.gunicorn.org/en/stable/configure.html#configuration-file
# https://docs.gunicorn.org/en/stable/settings.html
import multiprocessing

max_requests = 1000

max_requests_jitter = 100

log_file = '-'

workers = multiprocessing.cpu_count() + 1

bind = '0.0.0.0:8000'

timeout = 600

preload = True
