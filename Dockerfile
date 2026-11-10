# Moodle 4.0.12: legacy PHP 8.0 runtime. Use only in an isolated environment.
FROM php:8.0-apache-bullseye
# Debian Bullseye legacy repositories: use archived package indexes.
# This image is for isolated legacy Moodle installations only.
RUN sed -i 's|http://deb.debian.org/debian-security|http://archive.debian.org/debian-security|g; s|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Retries=3 update \
 && apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Retries=3 install -y --no-install-recommends \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libicu-dev libzip-dev \
    libxml2-dev libonig-dev libcurl4-openssl-dev default-mysql-client \
    ca-certificates unzip
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j"$(nproc)" gd intl zip soap mysqli pdo_mysql \
    opcache exif mbstring curl \
 && a2enmod rewrite headers \
 && rm -rf /var/lib/apt/lists/*
COPY docker/php-moodle.ini /usr/local/etc/php/conf.d/zz-moodle.ini
COPY docker/apache-moodle.conf /etc/apache2/sites-available/000-default.conf
COPY . /var/www/html/
COPY docker/config.php /var/www/html/config.php
COPY docker/entrypoint.sh /usr/local/bin/moodle-entrypoint
# CodeRunner question type and its required adaptive behaviour.
# Versions pinned for Moodle 4.0.12; the Jobe sandbox is deployed separately.
RUN mkdir -p /var/www/html/question/type/coderunner \
    /var/www/html/question/behaviour/adaptive_adapted_for_coderunner \
 && curl --fail --location --silent --show-error --retry 3 \
    https://github.com/trampgeek/moodle-qtype_coderunner/archive/refs/tags/v5.2.1.tar.gz \
    | tar -xz -C /var/www/html/question/type/coderunner --strip-components=1 \
 && curl --fail --location --silent --show-error --retry 3 \
    https://github.com/trampgeek/moodle-qbehaviour_adaptive_adapted_for_coderunner/archive/refs/tags/v1.4.2.tar.gz \
    | tar -xz -C /var/www/html/question/behaviour/adaptive_adapted_for_coderunner --strip-components=1
RUN chmod 0755 /usr/local/bin/moodle-entrypoint \
 && mkdir -p /var/moodledata \
 && chown -R www-data:www-data /var/moodledata \
 && chown -R root:www-data /var/www/html \
 && find /var/www/html -type d -exec chmod 0755 {} + \
 && find /var/www/html -type f -exec chmod 0644 {} +
WORKDIR /var/www/html
ENTRYPOINT ["/usr/local/bin/moodle-entrypoint"]
CMD ["apache2-foreground"]
