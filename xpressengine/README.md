Docker Xpressengine 3
=====================

업데이트 부진함.. 네이버에서 버린듯 폐기.
대체재:
- wordpress
- drupal
- joomla

다른것들도 있는데 커뮤니티 규모가 작거나 거의 레거시.. 업데이트 중지
상위3개를 사용
- octobercms https://github.com/octobercms/october
- grav https://github.com/getgrav/grav


도커용

# REF
- https://www.xpressengine.com/guide/getting-started/installation

### Test

docker run --rm -it php:7.4-alpine3.11 sh
docker run --rm -it php:7.4-zts-buster sh
docker run --rm -it php:7.4-fpm-buster sh


#### Test XE - Mysql

docker network create testnet
docker run --rm -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=xe_db --name mysql8 --net testnet mysql
docker run --rm -it --net testnet php:7.4-fpm bash

Run command in debian-buster/Dockerfile

