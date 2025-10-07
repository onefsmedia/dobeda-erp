FROM php:8.2-fpm-bookworm

# Install system packages required to build extensions
 RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libsasl2-dev \
    libkrb5-dev \
    libssl-dev \
    unzip \
    git \
   wget \
   build-essential \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 # Try to install libc-client-dev; if it's not available, build the UW c-client from source
 && apt-get update \
 && apt-get install -y --no-install-recommends libc-client-dev \
 && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
 && docker-php-ext-install -j"$(nproc)" gd mysqli pdo pdo_mysql zip imap \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy custom PHP configuration for file uploads
COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# Keep the base image's entrypoint/cmd (php-fpm)
