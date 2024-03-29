FROM php:7.4.33-fpm-alpine3.16

RUN apk upgrade --update \
  && apk add --no-cache --virtual .build-deps \
  $PHPIZE_DEPS \
  && apk add --no-cache \
  openssl-dev \
  freetype-dev \
  libjpeg-turbo-dev \
  libmcrypt-dev \
  libxml2-dev \
  libpng-dev \
  openssh \
  git \
  curl \
  bash \
  && docker-php-source extract \
  && docker-php-ext-configure gd \
  --with-freetype=/usr/include/ \
  --with-jpeg=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd pdo_mysql soap \
  && pecl install lzf redis-4.0.1 xdebug \
  && docker-php-ext-enable redis lzf \
  && docker-php-source delete \
  && apk del --no-network .build-deps \
  && ssh-keygen -A \
  && sed -i '/www-data/s/sbin\/nologin/bin\/bash/g' /etc/passwd \
  && echo 'www-data:www-data' | chpasswd # lol use in production for fun and games
