#!/bin/sh

python manage.py collectstatic --noinput || exit 1
exec "$@"
