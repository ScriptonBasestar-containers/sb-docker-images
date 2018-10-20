#!/bin/bash

ls /docker-entrypoint.d/ > /dev/null
for f in /docker-entrypoint.d/*; do
    bash "$f" -H
done

exec "$@"