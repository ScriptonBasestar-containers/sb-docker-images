ARG DOCKER_BASE_IMAGE=local_dev/flarum-base

FROM ${DOCKER_BASE_IMAGE} AS base-image


FROM php:8-fpm-alpine

# ARG WORKPATH=/var/www

RUN apk add libjpeg-turbo-dev libpng-dev freetype-dev libwebp-dev \
    nodejs npm
# RUN npm install -g @flarum/cli

RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/

RUN docker-php-ext-install -j$(nproc) gd pdo_mysql

# ARG WORKPATH=/var/www
COPY --from=base-image /app /var/www
