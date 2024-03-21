# FROM php:7.4-zts-buster
FROM php:7.4-apache-buster

ARG XE3_VERSION=3.0.11
ARG APP_ENV=production

ENV GID 799 \
    UID 799 \
    UPLOAD_MAX 100M \
    PHP_MEMORY_LIMIT=128M

ENV SITE_URL http://localhost \
    SITE_TIMEZONE Asia/Seoul \
    SITE_LOCALE ko \
    ADMIN_EMAIL admin@geek.re.kr \
    ADMIN_PASSWORD password \
    ADMIN_DISPLAY_NAME Admin \
    DB_DRIVER mysql \
    DB_HOST mysql \
    DB_PORT 3306 \
    DB_DATABASE xe_db \
    DB_USERNAME root \
    DB_PASSWORD password \
    DB_PREFIX

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
    sudo \
    wget \
    unzip \
    ca-certificates \
    apt-transport-https \
    git \
    zlib1g-dev \
    libpng-dev \
    libzip-dev \
    libcurl4-openssl-dev \
    python \
    python-pip \
    libonig-dev \
    ## terminal txt tmpl
    gettext-base

# php gd extension
RUN set -x \
    && docker-php-ext-install gd zip mbstring tokenizer curl pdo pdo_mysql fileinfo

# Cleanup
RUN set -x \
    && rm -rf /var/lib/apt/lists/*

# Get latest Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# COPY ./files/. /tmp/.
# COPY ./files/sample.env /var/www/html/.env
COPY ./files/.xe_install_config-tmpl.yml /tmp/.xe_install_config-tmpl.yml

# RUN rm -rf /var/www/html/* \
#     && git clone --depth=1 https://github.com/xpressengine/xpressengine.git /var/www/html
#     # && git clone --depth=1 https://github.com/ScriptonBasestar-io/xpressengine.git /var/www/html
WORKDIR /tmp
## download github latest
# RUN wget https://github.com/xpressengine/xpressengine/archive/${XE3_VERSION}.zip \
#     && unzip ${XE3_VERSION}.zip -d /var/www/html
# RUN chmod 0707 -R ./storage ./bootstrap ./config ./vendor ./plugins ./index.php ./composer.phar
# RUN COMPOSER_MEMORY_LIMIT=-1 composer require predis/predis --update-no-dev
# RUN COMPOSER_MEMORY_LIMIT=-1 composer install
# # RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev
# RUN composer fund
## latest
COPY ./files/latest.zip /tmp/latest.zip
RUN unzip /tmp/latest.zip -d /var/www/html
## installer
# RUN envsubst < /tmp/.xe_install_config-tmpl.yml > /tmp/.xe_install_config.yml
# RUN php -r "copy('http://start.xpressengine.io/download/installer', 'installer');" \
#     && php installer install --config=/tmp/.xe_install_config.yml --no-interact --install-dir=/var/www/html
# ENTRYPOINT [ "sh", "/var/www/html/install.sh" ]

WORKDIR /var/www/html
RUN chmod 0707 -R ./storage ./bootstrap ./config ./vendor ./plugins ./index.php ./composer.phar

RUN chown www-data:www-data -R /var/www/html
# USER www-data

# CMD [ "sh", "/var/www/html/install.sh" ]
CMD ["apache2-foreground"]