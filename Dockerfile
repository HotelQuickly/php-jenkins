FROM php:5.6-cli

ENV ANT_VERSION 1.9.7

RUN set -x \
  && curl -sSL https://getcomposer.org/composer.phar -o /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer \
  && curl -sSLO http://www-us.apache.org/dist//ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz \
  && tar -C /usr/local -xzf apache-ant-$ANT_VERSION-bin.tar.gz \
  && ln -s /usr/local/apache-ant-$ANT_VERSION/bin/ant /usr/local/bin/ant \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
  && echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
  && echo "deb http://httpredir.debian.org/debian/ jessie-backports main" | tee /etc/apt/sources.list.d/backports.list \
  && apt-get update \
  && apt-get install -y openjdk-8-jdk libicu-dev libcurl4-gnutls-dev libxml2-dev libssl-dev libmcrypt-dev git unzip mongodb-org-shell mysql-client --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install -j$(nproc) bcmath mcrypt pdo pdo_mysql mysqli dom json xml tokenizer curl mbstring simplexml intl \
  && pecl install mongodb \
  && echo '' | pecl install apcu-4.0.11 \
  && docker-php-ext-enable mongodb apcu
