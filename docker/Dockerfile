###########################
#
# Based: php:7.4-apache-buster
# https://hub.docker.com/_/php/
#
###########################

FROM php:7.4-apache-buster AS php-base

# from standard Drupal Dockerfile
# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
        libwebp-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype=/usr \
		--with-jpeg=/usr \
        --with-webp=/usr \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
	; \
	\

# For drush command tool to work
ENV PATH="/var/www/vendor/bin:$PATH"

RUN \
    # install package
    apt-get update && \
    apt-get install -y \
        links \
        mariadb-client \
        vim \
        wget \
        git \
        curl \
        sudo \
        zip \
        dos2unix \
        python-pip \
        gawk \
        jq \
        supervisor \
        rsyslog \
        libmemcached-dev \
        zlib1g-dev && \
    apt-get clean


RUN /usr/local/bin/docker-php-ext-install mysqli

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    php -r "unlink('composer-setup.php');"


RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush

RUN \
    # disable opcache for packaging
    # echo 'opcache.enable=0' > /usr/local/etc/php/conf.d/opcache-development.ini && \
    # permission
    # performance aggregate and compress js css files need to access following dirs
    # chown -R www-data /var/www/web/sites/*/files && \
    chmod +x /usr/local/bin/* && \

WORKDIR /var/www

RUN cd /var/www && \
    composer install
