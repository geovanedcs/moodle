# Moodle 4.0.12 (Build 20231211) - legacy runtime, not supported upstream.
FROM php:8.0-apache-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libicu-dev \
    libzip-dev libxml2-dev libonig-dev unzip \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j"$(nproc)" gd intl zip soap mysqli pdo_mysql \
    opcache exif mbstring \
 && a2enmod rewrite headers \
 && rm -rf /var/lib/apt/lists/*

RUN { \
      echo 'memory_limit=512M'; \
      echo 'upload_max_filesize=100M'; \
      echo 'post_max_size=110M'; \
      echo 'max_input_vars=5000'; \
      echo 'opcache.enable=1'; \
    } > /usr/local/etc/php/conf.d/moodle.ini

COPY . /var/www/html/
COPY docker/config.php /var/www/html/config.php

RUN mkdir -p /var/moodledata \
 && chown -R www-data:www-data /var/moodledata \
 && chmod 0770 /var/moodledata \
 && chown -R root:www-data /var/www/html \
 && find /var/www/html -type d -exec chmod 0755 {} + \
 && find /var/www/html -type f -exec chmod 0644 {} +

WORKDIR /var/www/html
