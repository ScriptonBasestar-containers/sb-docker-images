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

echo $DOCKER_IMGNAME
echo $CHEF_VERSION
echo $CUSTOM_USER

#--no-cache
docker build -t $DOCKER_REPONAME/$DOCKER_IMGNAME:$DOCKER_IMGVERSION --build-arg CUSTOM_USER=$CUSTOM_USER --build-arg CHEF_VERSION=${CHEF_VERSION} --no-cache . || { echo "command failed"; exit 1; }
#docker commit $DOCKER_REPONAME/$DOCKER_IMGNAME:$DOCKER_IMGVERSION || { echo "command failed"; exit 1; }
docker push $DOCKER_REPONAME/$DOCKER_IMGNAME:$DOCKER_IMGVERSION || { echo "command failed"; exit 1; }
