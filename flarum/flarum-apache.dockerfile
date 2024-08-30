ARG DOCKER_BASE_IMAGE=local_dev/flarum-base

FROM ${DOCKER_BASE_IMAGE} AS base-image



FROM php:8-apache

ARG WORKPATH=/var/www

RUN apt-get update && apt-get install -y \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libwebp-dev \
    nodejs \
    npm
# RUN npm install -g @flarum/cli

RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/

RUN docker-php-ext-install -j$(nproc) gd pdo_mysql

COPY ./config/apache/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf
COPY ./config/apache/status.conf /etc/apache2/mods-enabled/status.conf
COPY ./config/php/startup-apache-dev.sh /usr/local/bin/startup
COPY ./config/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
# COPY ./config/php/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# COPY ./config/php/sessions.ini /usr/local/etc/php/conf.d/sessions.ini
# COPY ./config/cronjobs/crontab /etc/cron.d/crontab


COPY --from=base-image /app /var/www
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www

RUN composer install \
  && chown -R www-data:www-data /var/www \
  && chmod -R g+w /var/www \
  && chmod 755 /usr/local/bin/startup

RUN a2enmod rewrite

RUN rm -rf /var/www/html

RUN chmod 775 -R /var/www
RUN chown -R www-data:www-data /var/www

RUN usermod -u 1000 www-data

# RUN cd /var/www
# RUN php flarum install

# RUN printenv | grep -v "no_proxy" >> /etc/environment

# RUN service cron start

# COPY docker-entrypoint.sh /entrypoint.sh

# ENTRYPOINT ['/entrypoint.sh']
# COMMAND ['apache2-foreground']
