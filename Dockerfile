ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-apache
MAINTAINER Matthew Poulter <https://github.com/mpltr>

# Use provided php.ini
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# can create cusom php.ini if required
# COPY ./php.ini "$PHP_INI_DIR/conf.d/php.ini"

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
    git \
    zip \
    curl \
    sudo \
    unzip \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    libpq-dev \
    libzip-dev \
    g++ \

    && docker-php-ext-install \
    bz2 \
    intl \
    iconv \
    bcmath \
    opcache \
    calendar \
    pdo_mysql \
    pdo_pgsql \
    zip

# Install composer via docker image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# Install composer via curl
# RUN curl -sS https://getcomposer.org/installer | php -- --version=2.0.8 && mv composer.phar /usr/local/bin/composer 

# change doc root to the public folder of laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
# mod_rewrite for .htaccess and headers
RUN a2enmod rewrite headers

# Installl Node
ARG NODE_VERSION=14.x
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION | bash
RUN apt-get install --yes nodejs



