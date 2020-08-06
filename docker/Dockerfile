###########################
#
# Based: php:7.4-apache-buster
# https://hub.docker.com/_/php/
#
# Run:
# docker run --name drupal-refportal
#
# Build:
# docker build -f docker/Dockerfile -t local/drupal-refportal .
# docker build -f docker/Dockerfile -t 582241766380.dkr.ecr.us-west-2.amazonaws.com/atlas/drupalrefportal:$ECR_TAG .
# $(cat logininfo.txt)
# docker push 582241766380.dkr.ecr.us-west-2.amazonaws.com/atlas/drupalrefportal:$ECR_TAG
#
###########################
# from https://www.drupal.org/docs/8/system-requirements/drupal-8-php-requirements
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
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# For drush command tool to work
ENV PATH="/var/www/vendor/bin:$PATH"

ADD docker/container-files /

RUN chmod -R 777 /tmp

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

RUN a2enmod remoteip
RUN a2enmod headers
RUN a2enmod expires

RUN pip install awscli

RUN /usr/local/bin/docker-php-ext-install mysqli

RUN pecl install memcached && \
    pecl install jsmin-3.0.0 && \
    /usr/local/bin/docker-php-ext-enable memcached jsmin

# include brotli support
RUN cd /usr/src && \
    git clone --recursive --depth=1 https://github.com/kjdev/php-ext-brotli.git && \
    cd php-ext-brotli && \
    phpize && \
    ./configure && \
    make && make install && \
    docker-php-ext-enable brotli

# https://circleci.com/blog/continuous-drupal-p1-maintaining-with-docker-git-composer/

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    php -r "unlink('composer-setup.php');"

RUN ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log \
    && ln -sf /dev/stdout /var/log/drupal.log

# disable kernel logging in rsyslog as it's a container, along with removing the redundant drupal logging (OP-5095)
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf && \
    perl -i -pe 's/([ \t]+-\/var\/log\/(syslog|debug|messages))/;\\\n\tlocal0.none$1/' /etc/rsyslog.conf

# Note PHP 7.4 requires v9.4+
# Current release: https://docs.newrelic.com/docs/release-notes/agent-release-notes/php-release-notes/php-agent-9110267
ENV NEWRELIC_VERSION=9.11.0.267

RUN \
    { curl -L https://download.newrelic.com/php_agent/release/newrelic-php5-${NEWRELIC_VERSION}-linux.tar.gz | tar -C /tmp -zx || \
    curl -L https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/newrelic-php5-${NEWRELIC_VERSION}-linux.tar.gz | tar -C /tmp -zx; } && \
    export NR_INSTALL_USE_CP_NOT_LN=1 && \
    export NR_INSTALL_SILENT=1 && \
    /tmp/newrelic-php5-${NEWRELIC_VERSION}-linux/newrelic-install install && \
    rm -rf /tmp/newrelic-php5-* /tmp/nrinstall*

RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush

RUN \
    # disable opcache for packaging
    # echo 'opcache.enable=0' > /usr/local/etc/php/conf.d/opcache-development.ini && \
    # permission
    # performance aggregate and compress js css files need to access following dirs
    # chown -R www-data /var/www/web/sites/*/files && \
    chmod -R 777 /tmp && \
    chmod +x /usr/local/bin/* && \
    mkdir -p /tmp/backups && \
    chown -R www-data /tmp/backups

WORKDIR /var/www

# CMD ["drupal-foreground"]
CMD ["/usr/bin/supervisord"]

# PHP Dev container
FROM php-base AS php-dev

# install xdebug for local development
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_autostart = 0" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_connect_back = 1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_port = 9000" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini

# Drupal container for deployments
FROM php-base AS drupal

ADD drupal /var/www
#ADD drupal/web/themes/lifepoints/images/apple-touch-icon.png /var/www/web/apple-touch-icon.png

# explicitly adding settings override for OP-1012 to work
ADD env/services.yml /var/www/web/sites/lifepoints/services.yml
ADD env/settings.php /var/www/web/sites/lifepoints/settings.php
ADD env/settings.local.php /var/www/web/sites/lifepoints/settings.local.php

RUN cd /var/www && \
    composer install

#RUN chown -R www-data:www-data web/sites web/modules web/themes && \
#    chmod ugo-wx web/sites/lifepoints/se*.*

# script based on Drupal best recommendations.  drupal_user is purposely not the apache (www-data) user.
RUN /usr/local/bin/fix-permissions.sh --drupal_path=/var/www/web --drupal_user=root
