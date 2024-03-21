# FROM php:7.4-zts-alpine3.11
FROM php:7.4-alpine3.11

ARG XE3_VERSION=3.0.11

ARG APP_ENV=production

ENV GID=799 \
    UID=799 \
    UPLOAD_MAX=100M \
    PHP_MEMORY_LIMIT=128M

ENV GID=799 \
    UID=799 \
    UPLOAD_MAX=100M \
    PHP_MEMORY_LIMIT=128M

ENV SITE_URL=http://localhost \
    SITE_TIMEZONE=Asia/Seoul \
    SITE_LOCALE=ko \
    ADMIN_EMAIL=admin@geek.re.kr \
    ADMIN_PASSWORD=password \
    ADMIN_DISPLAY_NAME=Admin \
    DB_DRIVER=mysql \
    DB_HOST=mysql \
    DB_PORT=3306 \
    DB_DATABASE=xe_db \
    DB_USERNAME=root \
    DB_PASSWORD=password \
    DB_PREFIX=""


RUN apk update && apk upgrade --no-progress

RUN apk add --no-progress --no-cache \
    nginx \
    s6 \
    su-exec \
    curl \
    git \
    libcap \
    composer \
    php7 \
    php7-fileinfo \
    php7-phar \
    php7-fpm \
    php7-curl \
    php7-mbstring \
    php7-openssl \
    php7-json \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqlnd \
    php7-zlib \
    php7-gd \
    php7-dom \
    php7-ctype \
    php7-session \
    php7-opcache \
    php7-xmlwriter \
    php7-tokenizer \
    php7-zip \
    php7-intl \
    php7-exif \
    php7-iconv

## php zip extension
RUN apk add --no-progress --no-cache \
    libzip-dev \
    zip \
    && docker-php-ext-install zip

## php pdo_mysql extension
RUN docker-php-ext-install pdo pdo_mysql

## php gd extension
RUN apk add --no-cache \
    libpng libpng-dev \
    libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev \
    && docker-php-ext-install gd \
    && apk del libpng-dev

## terminal txt tmpl
RUN apk add gettext

# Get latest Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /tmp

COPY ./files/. /tmp/.
# RUN git clone --depth=1 https://github.com/xpressengine/xpressengine.git /var/www/html
RUN wget https://github.com/xpressengine/xpressengine/archive/${XE3_VERSION}.zip \
    && unzip ${XE3_VERSION}.zip \
    && cp -r xpressengine-${XE3_VERSION}/. /var/www/html/ \
    && envsubst < /tmp/.xe_install_config-tmpl.yml > /var/www/html/.xe_install_config.yml \
    && rm -rf /tmp/*

WORKDIR /var/www/html
RUN composer install --no-dev; php artisan xe:install --config .xe_install_config.yml \
    && rm .xe_install_config.yml \
    && chown www-data:www-data -R /var/www/html

USER www-data
CMD ["apache2-foreground"]