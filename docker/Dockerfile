FROM debian:stretch-slim

ENV TZ=Europen/Zurich

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN nginx=stable

RUN apt-get autoclean && apt-get update -qqy && apt-get install -qqy \
    software-properties-common \
    wget \
    gnupg apt-transport-https \
    curl \
    mysql-client \
    git \
    unzip \
    nano \
    supervisor

## BASH COLOR
RUN  sed -i -e "s/#force_color_prompt=yes/force_color_prompt=yes/g" /root/.bashrc


## NGINX
RUN nginx=stable && \
    apt-get update && \
    apt-get install -qqy nginx

## NODEJS NPM
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && \
    apt-get install -qqy \
    nodejs \
    npm

RUN npm install -g grunt-cli

## PHP

RUN wget https://packages.sury.org/php/apt.gpg -O - | apt-key add -
RUN echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list
RUN apt-get update -qqy && \
    apt-get install -qqy \
    php7.2-fpm \
    php7.2-cli \
    php7.2-common \
    php7.2-curl \
    php7.2-json \
    php7.2-gd \
    php7.2-mbstring \
    php7.2-odbc \
    php7.2-pgsql \
    php7.2-mysql \
    php7.2-sqlite3 \
    php7.2-xmlrpc \
    php7.2-opcache \
    php7.2-intl \
    php7.2-xml \
    php7.2-soap \
    php7.2-zip \
    php7.2-bz2 \
    php7.2-bcmath \
    php7.2-xdebug \
    php7.2-dev 


## PHP DEPENDENCY
RUN apt-get update && apt-get install -qqy \
        libfreetype6-dev \        
        libmcrypt-dev \
        libpng-dev \      
        imagemagick \
        libxslt-dev \
        libcurl4-gnutls-dev \
        php-pear \
        libssl-dev
    # && docker-php-ext-install iconv \
    #             mcrypt \
    #             opcache \
    #             zip \
    #             curl \
    #             pdo \
    #             pdo_mysql \
    #             mbstring \
    #             soap \
    #             ftp \
    # && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    # && docker-php-ext-install gd \
    # && rm -rf /var/lib/apt/lists/*

## PHP MODULES
RUN apt-get update && apt-get install -y libmagickwand-6.q16-dev --no-install-recommends \
    && ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin/ \
    && pecl install imagick \
    && echo "extension=imagick.so" >  /etc/php/7.2/fpm/conf.d/20-imagick.ini \
    && pecl install redis \
    && echo "extension=redis.so" >  /etc/php/7.2/fpm/conf.d/20-redis.ini \
    && pecl install apcu \
    && echo "extension=apcu.so" > /etc/php/7.2/fpm/conf.d/20-apcu.ini \
    #&& pecl install xdebug
    #&& echo "extension=apcu.so" > /etc/php/7.2/fpm/conf.d/20-xdebug.ini \
    && rm -rf /var/lib/apt/lists/*


## NGINX CONFIG
RUN sed -i -e "s/worker_processes  1/worker_processes 5/" /etc/nginx/nginx.conf && \
    sed -i -e "s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
    sed -i -e "s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

## PHP CONFIG
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.2/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.2/fpm/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.2/fpm/php.ini && \ 
    sed -i -e "s/memory_limit\s*=\s*128M/memory_limit = 2048M/g" /etc/php/7.2/fpm/php.ini && \
    sed -i -e "s/max_execution_time\s*=\s*30/max_execution_time = 300/g" /etc/php/7.2/fpm/php.ini && \
    sed -i -e "s/cgi.fix_pathinfo=0/cgi.fix_pathinfo=1/g" /etc/php/7.2/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.2/cli/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.2/cli/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.2/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/;clear_env = no/clear_env = no/g" /etc/php/7.2/fpm/pool.d/www.conf

## XDEBUG CONFIG

RUN echo "xdebug.idekey=PHPSTORM" >> /etc/php/7.2/mods-available/xdebug.ini
RUN echo "xdebug.default_enable=0" >> /etc/php/7.2/mods-available/xdebug.ini
RUN echo "xdebug.remote_enable=on" >> /etc/php/7.2/mods-available/xdebug.ini
RUN echo "xdebug.remote_autostart=on" >> /etc/php/7.2/mods-available/xdebug.ini
RUN echo "xdebug.remote_connect_back=off" >> /etc/php/7.2/mods-available/xdebug.ini
RUN echo "xdebug.remote_handler=dbgp" >> /etc/php/7.2/mods-available/xdebug.ini
RUN echo "xdebug.profiler_enable=off" >> /etc/php/7.2/mods-available/xdebug.ini
RUN echo "xdebug.profiler_output_dir=/var/www" >> /etc/php/7.2/mods-available/xdebug.ini
RUN echo "xdebug.remote_port=9001" >> /etc/php/7.2/mods-available/xdebug.ini
RUN echo "xdebug.remote_host=%host_ip%" >> /etc/php/7.2/mods-available/xdebug.ini

## TIMEZONE
RUN printf '[PHP]\ndate.timezone = "Europe/Zurich"\n' > /etc/php/7.2/cli/php.ini


## PHP-FPM OWNERSHIP
RUN sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    find /etc/php/7.2/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# NGINX VHOST CONFIG
RUN rm -Rf /etc/nginx/nginx.d/* && \
    rm -Rf /etc/nginx/nginx.conf && \
    rm -Rf /etc/nginx/sites-available/default && \
    mkdir -p /etc/nginx/ssl/ && \
    mkdir -p /etc/nginx/snippets/
ADD ./docker/nginx/ssl/certs/localhost.crt /etc/nginx/ssl/certs/localhost.crt
ADD ./docker/nginx/ssl/private/localhost.key /etc/nginx/ssl/private/localhost.key
ADD ./docker/nginx/snippets/self-signed.conf /etc/nginx/snippets/self-signed.conf
ADD ./docker/nginx/snippets/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
ADD ./docker/nginx/dhparam.pem /etc/nginx/dhparam.pem
ADD ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/nginx/shopware.conf /etc/nginx/sites-available/shopware.conf
RUN ln -s /etc/nginx/sites-available/shopware.conf /etc/nginx/sites-enabled/shopware.conf


## INSTALL COMPOSER
RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
       mv composer.phar /usr/local/bin/composer

## DOCKER ERROR LOG
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

## SUPERVISIORD CONFIG
ADD ./docker/nginx/supervisord.conf /etc/supervisord.conf

## START
ADD ./docker/nginx/start.sh /start.sh
ADD ./run-shopware.sh /run-shopware.sh
RUN chmod 755 /start.sh
RUN chmod 755 /run-shopware.sh

RUN usermod -u 1000 www-data
RUN usermod -a -G users www-data

RUN mkdir -p /var/www
RUN chown -R www-data:www-data /var/www

RUN mkdir /run/php && chown www-data:www-data -R /run/php

WORKDIR /var/www

# Expose Ports
EXPOSE 443
EXPOSE 80

CMD ["/bin/bash", "/start.sh"]

ENTRYPOINT ["/run-shopware.sh"]