FROM php:5.6-cli

ENV ANT_VERSION 1.9.9
ENV NR_INSTALL_SILENT true

RUN set -x \
  && curl -sSL https://getcomposer.org/composer.phar -o /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer \
  && curl -sSLO http://www-us.apache.org/dist//ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz \
  && tar -C /usr/local -xzf apache-ant-$ANT_VERSION-bin.tar.gz \
  && ln -s /usr/local/apache-ant-$ANT_VERSION/bin/ant /usr/local/bin/ant \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
  && echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
  && echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
  && echo "deb http://httpredir.debian.org/debian/ jessie-backports main" | tee /etc/apt/sources.list.d/backports.list \
  && apt-get update \
  && wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add - \
  && apt install -y -t jessie-backports  openjdk-8-jre-headless ca-certificates-java \
  && apt-get install -y openjdk-8-jdk libicu-dev libcurl4-gnutls-dev libxml2-dev libssl-dev libmcrypt-dev git unzip mongodb-org-shell mysql-client newrelic-php5 --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install -j$(nproc) bcmath mcrypt pdo pdo_mysql mysqli dom json xml tokenizer curl mbstring simplexml intl zip soap

RUN pecl install mongodb \
  && newrelic-install install \
  && echo '' | pecl install apcu-4.0.11 \
  && docker-php-ext-enable mongodb apcu
