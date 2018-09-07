FROM debian:9.1

MAINTAINER dev@xtraball.com

RUN rm -f /etc/apt/sources.list
COPY ./dockerfiles/php-fpm/sources.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y curl wget
RUN apt-get install -y zip unzip vim
RUN apt-get install -y php-fpm php-mysql php-cli php-mbstring php-common php-gd php-mcrypt php-pdo php-xml php-mongodb php-curl php-sqlite3
RUN apt-get install -y cron

RUN rm -f /etc/php/7.0/fpm/pool.d/www.conf
COPY ./assets/php-fpm/docker.conf /etc/php/7.0/fpm/pool.d/
RUN rm -f /etc/php/7.0/fpm/php.ini
COPY ./assets/php-fpm/php.ini /etc/php/7.0/fpm/php.ini

WORKDIR /var/www/html

EXPOSE 9000

COPY ./assets/php-fpm/wrapper.sh /usr/bin/wrapper.sh
RUN chmod +x /usr/bin/wrapper.sh

CMD /usr/bin/wrapper.sh
