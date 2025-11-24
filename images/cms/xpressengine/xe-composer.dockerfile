# FROM composer:lts
FROM composer:

ARG XE_VERSION=3.1.1
ARG XE_INSTALL_DIR=/var/www/html
ARG XE_DATA_DIR=/data

WORKDIR ${XE_INSTALL_DIR}
COPY app/ ${XE_INSTALL_DIR}
RUN composer install
RUN php artisan xe:install

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 80/tcp

VOLUME ["${XE_DATA_DIR}"]

# ENTRYPOINT ["/sbin/entrypoint.sh"]
# CMD ["app:nextcloud"]
