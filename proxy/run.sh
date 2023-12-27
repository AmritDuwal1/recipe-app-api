#!/bin/sh

set -e

envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;'


# set -e

# python manage.py wait_for_db
# python manage.py collectstatic --noinput
# python manage.py migrate

# uwsgi --socket :9000 --workers 4 --master --enable-threads -module app.wsgi
