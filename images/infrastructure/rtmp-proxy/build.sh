#!/bin/bash


# TODO VERSION 가져와서 사용
source ./VERSION

docker build ./nginx \
-t scriptonbasestar/sb-rtmp-proxy-nginx:alpine \
-t scriptonbasestar/sb-rtmp-proxy-nginx:latest

docker build ./ubuntu \
-t scriptonbasestar/sb-rtmp-proxy-nginx:ubuntu \
-t scriptonbasestar/sb-rtmp-proxy-nginx:ub1804



docker push scriptonbasestar/sb-rtmp-proxy-nginx:alpine
docker push scriptonbasestar/sb-rtmp-proxy-nginx:latest

docker push scriptonbasestar/sb-rtmp-proxy-nginx:ubuntu
docker push scriptonbasestar/sb-rtmp-proxy-nginx:ub1804
