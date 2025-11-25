# Rhymix - Korean Open Source CMS
# https://github.com/rhymix/rhymix

ARG PHP_VERSION=8.2
FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="sb-docker-images"
LABEL description="Rhymix CMS - Korean open source CMS forked from XpressEngine"

# Install system dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    git \
    unzip \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    icu-dev \
    oniguruma-dev \
    libxml2-dev \
    imagemagick-dev \
    imagemagick

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        intl \
        mbstring \
        opcache \
        xml \
        fileinfo \
        exif

# Install ImageMagick extension
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apk del .build-deps

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/rhymix

# Download Rhymix from GitHub (no official releases, use source archive)
# Uses the default branch archive from GitHub
ARG RHYMIX_BRANCH=master
RUN curl -fsSL "https://github.com/rhymix/rhymix/archive/refs/heads/${RHYMIX_BRANCH}.tar.gz" -o rhymix.tar.gz \
    && tar -xzf rhymix.tar.gz --strip-components=1 \
    && rm rhymix.tar.gz \
    && chown -R www-data:www-data /var/www/rhymix

# Copy configuration files
COPY php.ini /usr/local/etc/php/conf.d/rhymix.ini
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create necessary directories
RUN mkdir -p /var/log/supervisor /run/nginx \
    && mkdir -p /var/www/rhymix/files \
    && chown -R www-data:www-data /var/www/rhymix/files

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
