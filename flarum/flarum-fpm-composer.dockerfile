FROM php:8-fpm-alpine

# ARG WORKPATH=/var/www

RUN apk add libjpeg-turbo-dev libpng-dev freetype-dev libwebp-dev \
    nodejs npm composer
RUN npm install -g @flarum/cli
RUN composer create-project flarum/flarum .

RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/

RUN docker-php-ext-install -j$(nproc) gd pdo_mysql

# COPY app/. $WORKPATH
