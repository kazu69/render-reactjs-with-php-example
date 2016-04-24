FROM php:5.6-apache

RUN apt-get update -y && \
    apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libbz2-dev \
    libv8-dev \
    php-pear \
    curl \
    git \
    unzip \
    build-essential

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup | bash - && \
    apt-get install -y nodejs && \
    npm cache clean && \
    npm i -g n && \
    n stable && \
    ln -sf /usr/local/bin/node /usr/bin/node

# https://pecl.php.net/package/v8js
# http://stackoverflow.com/questions/29229149/how-to-install-v8js-on-php5-5
RUN pecl install v8js-0.1.3 \
    && echo "extension=v8js.so" >> /etc/php5/cli/php.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# https://github.com/docker-library/php/blob/master/docker-php-ext-install
# オプションを追加してPHPをリコンパイルする
RUN docker-php-ext-install mcrypt zip bz2 mbstring \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && docker-php-ext-enable v8js

# https://github.com/reactjs/react-php-v8js
ADD ./php/composer.json /var/www

# Environmental Variables
ENV COMPOSER_HOME /var/www

# Add global binary directory to path
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

# add application
ADD ./react /var/www
ADD ./php/html /var/www/html
ADD ./php/package.json /var/www/package.json


WORKDIR /var/www

# composer install
RUN composer install

# build react application
RUN npm config set spin=false && \
    npm config set registry http://registry.npmjs.org/ && \
    npm i && \
    npm run build

ADD ./php/htaccess.txt /var/www/.htaccess
RUN chown www-data:www-data /var/www/.htaccess

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
