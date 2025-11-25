# AgenDAV - CalDAV web client
# https://agendav.github.io/agendav/
ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-fpm-alpine
LABEL maintainer="archmagece@gmail.com"
LABEL org.opencontainers.image.title="agendav"
LABEL org.opencontainers.image.description="AgenDAV - CalDAV web client"
LABEL org.opencontainers.image.source="https://github.com/scriptonbasestar/sb-docker-images"

ARG AGENDAV_VERSION=2.6.0

# Install system dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    git \
    unzip \
    icu-dev \
    libxml2-dev \
    oniguruma-dev

# Configure and install PHP extensions
RUN docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_mysql \
    intl \
    mbstring \
    xml \
    opcache

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Download and install AgenDAV
WORKDIR /var/www/agendav
RUN curl -fsSL "https://github.com/agendav/agendav/releases/download/${AGENDAV_VERSION}/agendav-${AGENDAV_VERSION}.tar.gz" -o agendav.tar.gz \
    && tar -xzf agendav.tar.gz --strip-components=1 \
    && rm agendav.tar.gz \
    && chown -R www-data:www-data /var/www/agendav

# Configure PHP
COPY php.ini /usr/local/etc/php/conf.d/agendav.ini

# Configure nginx
COPY nginx.conf /etc/nginx/http.d/default.conf

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Create directories
RUN mkdir -p /var/log/supervisor /run/nginx /var/www/agendav/var/cache /var/www/agendav/var/log \
    && chown -R www-data:www-data /var/www/agendav/var

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
