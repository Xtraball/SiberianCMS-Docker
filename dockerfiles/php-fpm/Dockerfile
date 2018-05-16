FROM debian:9.1

MAINTAINER dev@xtraball.com

RUN rm -f /etc/apt/sources.list
COPY ./dockerfiles/php-fpm/sources.list /etc/apt/sources.list

RUN apt update
RUN apt install -y optipng jpegoptim pngquant
RUN apt install -y curl wget
RUN apt install -y zip unzip vim
RUN apt install -y php-fpm php-mysql php-cli php-common php-gd php-mcrypt php-pdo php-xml php-mongodb php-curl php-sqlite3
RUN apt install -y net-tools
RUN apt install -y openjdk-8-jdk openjdk-8-jre
RUN apt install -y cron
RUN apt install -y lib32z1 lib32z1-dev
RUN apt install -y nodejs
RUN echo "postfix postfix/mailname string tigerappcreator.com" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string 'Internet Site" | debconf-set-selections
RUN apt install -y postfix


RUN rm -f /etc/php/7.0/fpm/pool.d/www.conf
COPY ./assets/php-fpm/docker.conf /etc/php/7.0/fpm/pool.d/
RUN rm -f /etc/php/7.0/fpm/php.ini
COPY ./assets/php-fpm/php.ini /etc/php/7.0/fpm/php.ini
COPY ./assets/php-fpm/crontab /tmp/crontab

# Install the default Siberian CRON Scheduler
RUN crontab -u www-data /tmp/crontab
#RUN (crontab -l -u www-data; echo "* * * * * /usr/bin/php -d memory_limit=512M -f /var/www/html/cron.php >> /var/www/html/var/log/cron.log 2>&1") | crontab -u www-data

WORKDIR /var/www/html

EXPOSE 9000

COPY ./assets/php-fpm/wrapper.sh /usr/bin/wrapper.sh
RUN chmod +x /usr/bin/wrapper.sh

CMD /usr/bin/wrapper.sh
