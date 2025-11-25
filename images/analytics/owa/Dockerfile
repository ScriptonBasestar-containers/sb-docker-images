# Open Web Analytics (OWA)
# Self-hosted web analytics platform
# https://www.openwebanalytics.com/
ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-fpm-alpine
LABEL maintainer="archmagece@gmail.com"
LABEL org.opencontainers.image.title="open-web-analytics"
LABEL org.opencontainers.image.description="Open Web Analytics - self-hosted web analytics"
LABEL org.opencontainers.image.source="https://github.com/scriptonbasestar/sb-docker-images"

ARG OWA_VERSION=1.7.8

# Install dependencies
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
    oniguruma-dev

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        intl \
        mbstring \
        opcache

# Download OWA
WORKDIR /var/www/html
RUN curl -fsSL "https://github.com/Open-Web-Analytics/Open-Web-Analytics/archive/refs/tags/${OWA_VERSION}.tar.gz" -o owa.tar.gz \
    && tar -xzf owa.tar.gz --strip-components=1 \
    && rm owa.tar.gz \
    && chown -R www-data:www-data /var/www/html

# Configure PHP
COPY php.ini /usr/local/etc/php/conf.d/owa.ini

# Configure nginx
COPY nginx.conf /etc/nginx/http.d/default.conf

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create directories
RUN mkdir -p /var/log/supervisor /run/nginx

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost/index.php || exit 1

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
