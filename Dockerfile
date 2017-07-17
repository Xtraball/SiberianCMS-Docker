FROM centos:7

MAINTAINER dev@xtraball.com

RUN yum update
RUN yum install -y openssh openssh-server \
    nginx php-fpm php-cli php-common php-devel \
    php-gd php-magickwand php-mbstring \
    php-mcrypt php-mysql php-pdo php-xml \
    php-mongodb zip unzip curl wget composer.noarch \
    optipng jpegoptim pngquant git

COPY assets/wrapper /usr/local/bin/wrapper
RUN chmod +x /usr/local/bin/wrapper

EXPOSE 22 80 443 35500-36000
