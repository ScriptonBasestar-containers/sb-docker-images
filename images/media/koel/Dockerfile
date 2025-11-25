# Koel - Personal music streaming server
# https://koel.dev/
ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-fpm-alpine
LABEL maintainer="archmagece@gmail.com"
LABEL org.opencontainers.image.title="koel"
LABEL org.opencontainers.image.description="Koel - Personal music streaming server"
LABEL org.opencontainers.image.source="https://github.com/scriptonbasestar/sb-docker-images"

ARG KOEL_VERSION=7.0.9

# Install system dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    git \
    curl \
    unzip \
    ffmpeg \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    icu-dev \
    oniguruma-dev \
    linux-headers \
    $PHPIZE_DEPS

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        pdo \
        pdo_mysql \
        zip \
        intl \
        mbstring \
        opcache \
        bcmath \
        exif

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Download and install Koel
WORKDIR /var/www/koel
RUN curl -fsSL "https://github.com/koel/koel/releases/download/v${KOEL_VERSION}/koel-v${KOEL_VERSION}.tar.gz" -o koel.tar.gz \
    && tar -xzf koel.tar.gz --strip-components=1 \
    && rm koel.tar.gz \
    && chown -R www-data:www-data /var/www/koel

# Configure PHP
COPY php.ini /usr/local/etc/php/conf.d/koel.ini

# Configure nginx
COPY nginx.conf /etc/nginx/http.d/default.conf

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create directories
RUN mkdir -p /var/log/supervisor /run/nginx /music /covers

# Set permissions
RUN chown -R www-data:www-data /music /covers

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost/api/ping || exit 1

EXPOSE 80

VOLUME ["/music", "/covers"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
