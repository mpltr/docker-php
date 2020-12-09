FROM php:7.2-apache
MAINTAINER Matthew Poulter <https://github.com/mpltr>

# Use provided php.ini
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Install  dependencies
RUN apt-get update \
    && apt-get install -y \
    nodejs \
    npm \
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
    g++ 

# Install composer via docker image
COPY --from=composer:2.0.7 /usr/bin/composer /usr/bin/composer
# Install composer via curl
# RUN curl -sS https://getcomposer.org/installer | php -- --version=2.0.8 && mv composer.phar /usr/local/bin/composer 



