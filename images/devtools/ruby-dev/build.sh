#!/bin/bash

#https://github.com/builtinnya/dotenv-shell-loader
dotenv () {
  DOTENV_SHELL_LOADER_SAVED_OPTS=$(set +o)
  set -o allexport
  [ -f .env ] && source .env
  set +o allexport
  eval "$DOTENV_SHELL_LOADER_SAVED_OPTS"
  unset DOTENV_SHELL_LOADER_SAVED_OPTS
}
dotenv

docker build -t $DOCKER_REPONAME/$DOCKER_IMGNAME:$DOCKER_IMGVERSION \
--build-arg RUBY_VERSION=${RUBY_VERSION} \
--build-arg RAILS_VERSION=${RAILS_VERSION} \
--build-arg CUSTOM_USER=${CUSTOM_USER} \
--no-cache . || { echo "command failed"; exit 1; }
#docker commit $DOCKER_REPONAME/$DOCKER_IMGNAME:$DOCKER_IMGVERSION || { echo "command failed"; exit 1; }
docker push $DOCKER_REPONAME/$DOCKER_IMGNAME:$DOCKER_IMGVERSION || { echo "command failed"; exit 1; }
