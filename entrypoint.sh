#!/bin/bash

exec tini -- daphne -b $DAPHNE_PORT --access-log - "$@" $APP_ASGI_ENTRYPOINT
