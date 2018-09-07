FROM debian:9.1

MAINTAINER dev@xtraball.com

RUN rm -f /etc/apt/sources.list
COPY ./dockerfiles/php-fpm/sources.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y curl wget
RUN apt-get install -y apt-transport-https lsb-release ca-certificates
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN apt-get install -y zip unzip vim
RUN apt-get install -y php5.6-fpm php5.6-mysql php5.6-cli php5.6-mbstring php5.6-common php5.6-gd php5.6-mcrypt php5.6-pdo php5.6-xml php5.6-curl
RUN apt-get install -y cron

RUN rm -f /etc/php/5.6/fpm/pool.d/www.conf
COPY ./assets/php-fpm/docker.conf /etc/php/5.6/fpm/pool.d/
RUN rm -f /etc/php/5.6/fpm/php.ini
COPY ./assets/php-fpm/php.ini /etc/php/5.6/fpm/php.ini

WORKDIR /var/www/html

EXPOSE 9000

COPY ./assets/php-fpm/wrapper.sh /usr/bin/wrapper.sh
RUN chmod +x /usr/bin/wrapper.sh

CMD /usr/bin/wrapper.sh
