FROM php:7.2.19-fpm-alpine3.10

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
  --with-freetype-dir=/usr/include/ \
  --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd pdo_mysql soap \
  && pecl install lzf redis-4.0.1 \
  && docker-php-ext-enable redis lzf \
  && docker-php-source delete \
  && apk del --no-network .build-deps \
  && ssh-keygen -A \
  && sed -i '/www-data/s/sbin\/nologin/bin\/bash/g' /etc/passwd \
  && echo 'www-data:www-data' | chpasswd # lol use in production for fun and games
