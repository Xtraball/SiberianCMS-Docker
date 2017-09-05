FROM debian:9.1

MAINTAINER dev@xtraball.com

RUN rm -f /etc/apt/sources.list
COPY ./dockerfiles/php-fpm/sources.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y optipng jpegoptim pngquant
RUN apt-get install -y curl wget
RUN apt-get install -y zip unzip vim
RUN apt-get install -y php-fpm php-mysql php-cli php-common php-gd php-mcrypt php-pdo php-xml php-mongodb php-curl php-sqlite3
RUN apt-get install -y net-tools
RUN apt-get install -y openjdk-8-jdk openjdk-8-jre
RUN apt-get install -y cron
RUN apt-get install -y lib32z1 lib32z1-dev
RUN apt-get install -y nodejs

RUN rm -f /etc/php/7.0/fpm/pool.d/www.conf
COPY ./assets/php-fpm/docker.conf /etc/php/7.0/fpm/pool.d/
RUN rm -f /etc/php/7.0/fpm/php.ini
COPY ./assets/php-fpm/php.ini /etc/php/7.0/fpm/php.ini

# Install the default Siberian CRON Scheduler
RUN (crontab -l ; echo "* * * * * /usr/bin/php -d memory_limit=512M -f /var/www/html/cron.php >> /var/www/html/var/log/cron.log 2>&1") | crontab

WORKDIR /var/www/html

EXPOSE 9000

RUN service php7.0-fpm start
RUN service cron start

CMD php-fpm7.0 -F