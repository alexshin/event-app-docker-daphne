#!/bin/bash

case "$@" in
    manage.py*) exec "./$@";;
    bash*|sh*) exec bash;;
    * ) exec tini -- daphne -b 0.0.0.0 -p $DAPHNE_PORT --access-log - "$@" $APP_ASGI_ENTRYPOINT;;
esac
