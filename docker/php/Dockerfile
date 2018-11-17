FROM php:7.0.32-fpm-alpine

LABEL maintainer "Shoma Nishitateno <shoma416@gmail.com>"

# Environment variable
ARG MYSQL_VERSION=10.1.32-r0
ARG APCU_VERSION=5.1.8
ARG APCU_BC_VERSION=1.0.3
ARG PHP_VERSION=7.0.16-r0

RUN apk update \
	&& apk add --no-cache \
		libbz2 \
		gd \
		gettext \
		libmcrypt \
		libxslt \
	&& apk add --no-cache --virtual .build-php \
		$PHPIZE_DEPS \
		mariadb=${MYSQL_VERSION} \
		mariadb-dev=${MYSQL_VERSION} \
		gd-dev \
		jpeg-dev \
		libpng-dev \
		libwebp-dev \
		libxpm-dev \
		zlib-dev \
		freetype-dev \
		bzip2-dev \
		libexif-dev \
		xmlrpc-c-dev \
		pcre-dev \
		gettext-dev \
		libmcrypt-dev \
		libxslt-dev \
	&& pecl install apcu-$APCU_VERSION \
	&& docker-php-ext-enable apcu \
	&& pecl install apcu_bc-$APCU_BC_VERSION \
	&& docker-php-ext-enable apc \
	&& docker-php-ext-install \
		mysqli \
		opcache \
		gd \
		bz2 \
		pdo pdo_mysql \
		bcmath exif gettext mcrypt pcntl \
		soap sockets sysvsem sysvshm xmlrpc xsl zip \
	&& apk del .build-php \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-apc.ini \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
	&& mkdir -p /etc/php.d/

COPY *.ini /usr/local/etc/php/conf.d/
COPY opcache*.blacklist /etc/php.d/

RUN set -xe \
	&& apk update \
	&& apk add --no-cache wget mariadb-client=${MYSQL_VERSION}

# Install wp-cli
RUN set -xe \
	&& wget https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp \
	&& chmod u+x /usr/local/bin/wp

# Download wordpress
RUN set -xe \
	&& rm -rf /var/www/html \
	&& wp core download --locale=ja --path=/var/www/html --allow-root \
	&& chown -R 1000:1000 /var/www/html \
	&& mkdir -p /var/www/html/wp-content/uploads \
	&& chmod -R 777 /var/www/html/wp-content/uploads

WORKDIR /var/www/html
