FROM composer:2

# RUN apt-get update && apt-get install -y \
#     libzip-dev \
#     zlib1g-dev \
#     && rm -rf /var/lib/apt/lists/*
# Install required dependencies and PHP extensions
RUN apk add --no-cache \
    libzip-dev \
    zlib-dev \
    libpng-dev \
    libbz2 \
    libsodium-dev \
    && docker-php-ext-install gd bz2 sodium zip
RUN docker-php-ext-enable gd bz2 sodium zip


# ARG DRUPAL_VERSION=
# 7.x-dev
# 9.x-dev

RUN composer create-project drupal/recommended-project .
# RUN composer create-project drupal/recommended-project:${DRUPAL_VERSION} /app

RUN composer global require drush/drush

RUN composer require drupal/token drupal/ctools

# RUN composer require 'drupal/token:^1.5'
# RUN composer require 'drupal/simple_fb_connect:~3.0'
# RUN composer require 'drupal/ctools:3.0.0-alpha26'
# RUN composer require 'drupal/token:1.x-dev'
