FROM php:8.1.27-apache-bookworm
#FROM php:8.1-apache-bullseye                                                                                          
LABEL maintainer="morganzero@sushibox.dev"
LABEL description="Dockerized Debian-Apache-PHP-IonCube WebServer"
LABEL name="DAPI"

# Install Dependencies
RUN apt-get update && apt-get upgrade -y \
    && curl -sSL https://packages.sury.org/php/README.txt | bash -x \
    && apt-get install -y --no-install-recommends unzip zlib1g-dev libpng-dev libicu-dev ca-certificates apt-transport-https software-properties-common wget curl jq nano lsb-release gettext-base

# Configure Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY apache2.conf /etc/apache2/apache2.conf
COPY start-apache /usr/local/bin
RUN mkdir -p /etc/webserver
RUN mkdir -p /var/log/webserver
RUN chmod +x /usr/local/bin/start-apache \
    && a2enmod rewrite \
    && a2enmod ssl

# Download WHMCS
#RUN set -eux \
#    && whmcs_release=$(curl -sX GET 'https://api1.whmcs.com/download/latest?type=stable' | jq -r '.version') \
#    && wget -P /tmp --user-agent="Mozilla" https://releases.whmcs.com/v2/pkgs/whmcs-${whmcs_release}-release.1.zip \
#    && unzip /tmp/whmcs-${whmcs_release}-release.1.zip -d /var/www/html/whmcs \
#    && chown -R www-data:www-data /var/www/html

#ARG whmcs_release
#RUN whmcs_release=$(curl -sX GET 'https://api1.whmcs.com/download/latest?type=stable' | jq -r '.version')
#LABEL whmcs_version="${whmcs_release}"

# Install PHP 8.1 Extensions
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libgmp-dev libzip-dev libonig-dev libxml2-dev libcurl4-openssl-dev libicu-dev libssl-dev curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) gd gmp bcmath intl zip pdo_mysql mysqli soap calendar opcache curl iconv mbstring exif xml

# Configure opcache
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Install IonCube Loader
RUN wget -P /tmp https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -zxvf /tmp/ioncube_loaders_lin_x86-64.tar.gz -C /tmp \
    && loaded_conf=$(php -i | awk '/Loaded Configuration File/{print $5}') \
    && mkdir /usr/local/bin/ioncube \
    && cp /tmp/ioncube/ioncube_loader_lin_8.1.so /usr/local/bin/ioncube/ \
    && echo "zend_extension=/usr/local/bin/ioncube/ioncube_loader_lin_8.1.so" >> /usr/local/etc/php/php.ini

# Clear out trash
RUN apt-get autoclean -y \
    && apt-get autoremove --purge -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

CMD ["start-apache"]
