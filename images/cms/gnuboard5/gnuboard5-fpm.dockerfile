FROM php:8-fpm-alpine

#ARG WORKPATH=/var/www/html

RUN apk add libjpeg-turbo-dev libpng-dev freetype-dev libwebp-dev

RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/

RUN docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli

RUN apk --no-cache update \
    && apk --no-cache upgrade \
    && apk add --no-cache mysql-client

#RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
#RUN echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
#
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
#    php-gd php-mysql

#COPY app/. $WORKPATH

#RUN chmod 701 $WORKPATH
#RUN #mkdir $WORKPATH/data
#RUN mkdir $WORKPATH/data
#RUN chmod 701 $WORKPATH/data

#CMD ["php-fpm"]