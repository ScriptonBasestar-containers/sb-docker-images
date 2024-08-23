FROM composer:lts

ARG XE_VERSION=29.0.5

ENV XE_VERSION=${XE_VERSION} \
    XE_USER=${PHP_FPM_USER} \
    NEXTCLOUD_INSTALL_DIR=/var/www/nextcloud \
    NEXTCLOUD_DATA_DIR=/var/lib/nextcloud \
    NEXTCLOUD_CACHE_DIR=/etc/docker-nextcloud

ENV NEXTCLOUD_BUILD_DIR=${NEXTCLOUD_CACHE_DIR}/build \
    NEXTCLOUD_RUNTIME_DIR=${NEXTCLOUD_CACHE_DIR}/runtime

RUN apt-get update \
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    php8.0-pgsql php8.0-mysql php8.0-gd \
    php8.0-curl php8.0-intl php8.0-mcrypt php8.0-ldap \
    php8.0-gmp php8.0-apcu php8.0-imagick \
    mysql-client postgresql-client nginx gettext-base \
 && rm -rf /var/lib/apt/lists/*

WORKDIR ${NEXTCLOUD_INSTALL_DIR}
COPY xpressengine/ ${NEXTCLOUD_INSTALL_DIR}
RUN composer install
RUN php artisan xe:install

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 80/tcp

VOLUME ["${NEXTCLOUD_DATA_DIR}"]

WORKDIR ${NEXTCLOUD_INSTALL_DIR}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:nextcloud"]