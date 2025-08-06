FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

#================================================
# Update and install base packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    apt-utils \
    curl \
    wget \
    unzip \
    git \
    mysql-client \
    sudo \
    vim \
    bzip2 \
    htop \
    software-properties-common \
    build-essential \
    libssl-dev \
    libsqlite3-dev \
    ruby \
    ruby-dev \
    apache2

#================================================
# Add repositories for PHP & Apache
RUN add-apt-repository ppa:ondrej/php \
 && apt-get update && apt-get install -y \
    php8.4 \
    php8.4-common \
    php8.4-cli \
    php8.4-curl \
    php8.4-dev \
    php8.4-mysql \
    php8.4-soap \
    php8.4-intl \
    php8.4-gd \
    php8.4-mbstring \
    php8.4-zip \
    php8.4-xml \
    php8.4-bcmath \
    php-xdebug \
    libapache2-mod-php8.4

# Enable Apache modules
RUN a2enmod rewrite

# Change Apache web root to /var/www/html/web
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/web|g' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's|<Directory /var/www/html/>|<Directory /var/www/html/web/>|g' /etc/apache2/apache2.conf  

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer

# Install Drush globally (Drupal CLI)
RUN composer global require drush/drush \
 && ln -s ~/.composer/vendor/bin/drush /usr/local/bin/drush

#================================================
# Set working directory and permissions
WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 755 /var/www/html/

# ================================================
# Copy composer depndencies
COPY ./composer.json /var/www/html/composer.json
COPY ./composer.lock /var/www/html/composer.lock

#================================================
# Install composer packages
RUN cd /var/www/html/ && \
composer install

# Expose ports
EXPOSE 80

# Set entrypoint
CMD ["apachectl", "-D", "FOREGROUND"]
