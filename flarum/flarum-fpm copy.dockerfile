FROM php:8-fpm-alpine

# ARG WORKPATH=/var/www

RUN apk add libjpeg-turbo-dev \
    libpng-dev \
    libpng \
    libwebp-dev \
    libwebp \
    freetype-dev \
    freetype \
    libjpeg-turbo \
    libzip-dev \
    unzip \
    libxml2-dev

RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/

RUN docker-php-ext-install -j$(nproc) gd pdo_mysql zip
# mbstring exif pcntl bcmath

# COPY app/. $WORKPATH

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer require kk14569/flarum-hubui-x

