Docker Xpressengine 3
=====================

도커용


### Test

docker run --rm -it php:7.4-alpine3.11 sh
docker run --rm -it php:7.4-zts-buster sh
docker run --rm -it php:7.4-fpm-buster sh


#### Test XE - Mysql

docker network create testnet
docker run --rm -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=xe_db --name mysql8 --net testnet mysql
docker run --rm -it --net testnet php:7.4-fpm bash

Run command in debian-buster/Dockerfile

