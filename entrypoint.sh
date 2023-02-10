#!/bin/sh

python manage.py migrate --noinput || exit 1
exec "$@"
