#!/bin/bash

if [[ ! -d /wiki/.git ]]
then
    git init --bare /wiki
fi

"$@"