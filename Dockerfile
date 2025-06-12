FROM php:8.3-fpm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    libpng-dev libjpeg-dev libldap2-dev libcurl4-openssl-dev \
    libxml2-dev libfreetype6-dev libbz2-dev libzip-dev zlib1g-dev pkg-config \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        mysqli \
        gd \
        ldap \
        curl \
        xml \
        intl \
        exif \
        bz2 \
        zip \
        opcache

# Download and extract GLPI
RUN curl -L -o /tmp/glpi.tar.gz https://github.com/glpi-project/glpi/releases/download/10.0.18/glpi-10.0.18.tgz && \
    mkdir -p /var/www/html && \
    tar xzf /tmp/glpi.tar.gz -C /var/www/html && \
    rm /tmp/glpi.tar.gz && \
    chown -R www-data:www-data /var/www/html/glpi

WORKDIR /var/www/html/glpi
