FROM php:8.1-cli-alpine

RUN apk add --no-cache \
      icu-dev 
 
RUN docker-php-ext-install \
    -j$(nproc) \
    intl \
    pcntl \
    pdo_mysql \
    mysqli 

COPY ./app /app