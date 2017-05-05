FROM centos:7

MAINTAINER dev@xtraball.com

RUN yum update
RUN yum install -y openssh openssh-server
RUN yum install -y nginx
RUN yum install -y php-fpm php-cli php-common php-devel php-gd php-magickwand php-mbstring php-mcrypt \
    php-mysql php-pdo php-xml php-mongodb
RUN yum install -y composer.noarch
RUN yum install -y optipng jpegoptim pngquant
RUN yum -y install git

RUN git clone https://github.com/Xtraball/SiberianCMS.git /var/www/siberian

EXPOSE 22 80 443 35000-35500