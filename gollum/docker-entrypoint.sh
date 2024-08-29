#!/bin/bash

if [[ ! -d /wiki/.git ]]
then
    git init --bare /wiki
    mkdir -p /wiki/gollum
    if [[ ! -d /wiki/gollum/.git ]]
    then
        git init --bare /wiki/gollum
    fi
fi

chown -R 1000:1000 /wiki

"$@"