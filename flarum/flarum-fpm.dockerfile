FROM php:8-fpm-alpine

RUN apk add libjpeg-turbo-dev libpng-dev freetype-dev libwebp-dev

RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/

RUN docker-php-ext-install -j$(nproc) gd pdo_mysql
