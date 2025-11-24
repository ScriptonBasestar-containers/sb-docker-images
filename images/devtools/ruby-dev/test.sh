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

# $1 command line argument
# $2 dotenv
nullDefaultValue() {
  echo $1
  echo $2
  if [ -z $1 || $2]
  then
    echo "1111111111"
  else
    echo "2222222222"
  fi
}

#https://unix.stackexchange.com/questions/331522/how-do-i-parse-optional-arguments-in-a-bash-script-if-no-order-is-given
while :; do
    case $1 in
        -a|--flag1) flag1="SET"            
        ;;
        -b|--flag2) flag2="SET"            
        ;;
        -c|--optflag1) optflag1="SET"            
        ;;
        -d|--optflag2) optflag2="SET"            
        ;;
        -e|--optflag3) optflag3="SET"            
        ;;
        *) break
    esac
    shift
done



nullDefaultValue ${ARGUMENTS['ruby_version']} $RUBY_VERSION 

RUBY_VERSION=$ARGUMENTS['ruby_version']
RAILS_VERSION=$ARGUMENTS['ruby_version']
NODE_VERSION=$ARGUMENTS['ruby_version']
DOCKER_REPONAME=$ARGUMENTS['ruby_version']
DOCKER_IMGNAME=$ARGUMENTS['ruby_version']
DOCKER_IMGVERSION=$ARGUMENTS['ruby_version']
#path=$ARGUMENTS['path']
#docker_username=$ARGUMENTS['path']
#docker_reponame=
