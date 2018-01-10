FROM ubuntu:latest

RUN locale-gen en_US.UTF-8 \
	&& export LANG=en_US.UTF-8 \
	&& apt-get update \
	&& apt-get install -y software-properties-common \
	&& apt-get install -y language-pack-en-base \
	&& LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php \
	&& apt-get update

RUN apt-get -y install \
    apache2 \
    sqlite3 \
    curl \
    imagemagick \
    nano \
    mcrypt \
    git-core \
    wget

RUN a2enmod headers \
    && a2enmod rewrite


RUN apt-get -y install \
    libapache2-mod-php7.0 \
    php7.0 \
    php7.0-cli \
    php-xdebug \
    php7.0-mbstring \
    php7.0-mysql \
    php-imagick \
    php-memcached \
    php-pear \
    php7.0-dev \
    php7.0-gd \
    php7.0-opcache \
    php7.0-mcrypt \
    php-redis \
    php7.0-json \
    php7.0-curl \
    php7.0-sqlite3 \
    php7.0-intl \
    php7.0-bcmath \
    libsasl2-dev \
    libssl-dev \
    libsslcommon2-dev \
    libcurl4-openssl-dev \


RUN pecl install mongodb \
	&& echo "extension=mongodb.so" > /etc/php/7.0/mods-available/mongodb.ini && \
	&& ln -s /etc/php/7.0/mods-available/mongodb.ini /etc/php/7.0/apache2/conf.d/20-mongodb.ini && \
	&& ln -s /etc/php/7.0/mods-available/mongodb.ini /etc/php/7.0/cli/conf.d/20-mongodb.ini

# Configure PHP
# RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/apache2/php.ini


RUN apt-get autoremove -y \
    && apt-get clean \
	&& rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR


VOLUME [ "/var/www/html" ]
WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/apache2" ]
CMD ["-D", "FOREGROUND"]
