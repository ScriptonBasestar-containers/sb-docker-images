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

LOCAL_PATH=$1
if [ -z "$LOCAL_PATH" ]
then
  echo "경로를 지정하지 않앗습니다. 종료합니다."
  echo "ex) $ ./run.sh /work/railsapp"
  exit 1
  #LOCAL_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
else
  echo "프로젝트 경로 : " $LOCAL_PATH
fi

echo $LOCAL_PATH

docker run -ti -p 3000:3000 -v "$LOCAL_PATH:/app" -v gempath:/usr/local/bundle --link mysql:mysql $DOCKER_REPONAME/$DOCKER_IMGNAME:$DOCKER_IMGVERSION bash
