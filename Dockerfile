# ----- Stage 1: Builder -----
FROM php:8.3-fpm AS builder

# Install build dependencies and compile PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpng-dev libjpeg-dev libldap2-dev libcurl4-openssl-dev libxml2-dev \
 && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
        --with-xpm \
 && docker-php-ext-install mysqli gd ldap curl xml intl exif bz2 zip opcache \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# ----- Stage 2: Final Image -----
FROM php:8.3-fpm

# Copy compiled PHP extensions from builder
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d

# Download and extract GLPI
RUN curl -L -o /tmp/glpi.tar.gz https://github.com/glpi-project/glpi/releases/download/10.0.18/glpi-10.0.18.tgz && \
    mkdir -p /var/www/html && \
    tar xzf /tmp/glpi.tar.gz -C /var/www/html && \
    rm /tmp/glpi.tar.gz && \
    chown -R www-data:www-data /var/www/html/glpi

WORKDIR /var/www/html/glpi
