#!/bin/bash

git config --global user.email "archmagece@gmail.com"
git config --global user.name "cee"

ls /docker-entrypoint.d/ > /dev/null
for f in /docker-entrypoint.d/*; do
    bash "$f" -H
done


exec "$@"
