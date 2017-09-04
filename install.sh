#!/bin/bash

# Generates a temporary SSL certificate
openssl genrsa -des3 -passout pass:x -out ./etc/ssl/default.pass.key 2048
openssl rsa -passin pass:x -in ./etc/ssl/default.pass.key -out ./etc/ssl/default.key
rm ./etc/ssl/default.pass.key
openssl req -new -key ./etc/ssl/default.key -out ./etc/ssl/default.csr \
  -subj "/C=FR/ST=Haute-Garonne/L=Toulouse/O=Xtraball/OU=SysAdmin/CN=mysiberian.example.com"
openssl x509 -req -days 365 -in ./etc/ssl/default.csr -signkey ./etc/ssl/default.key -out ./etc/ssl/default.crt

# Generates a Random MySQL Password
password=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13`
sed -i'' s/MYSQL_ROOT_PASSWORD=changeme/MYSQL_ROOT_PASSWORD=$password/g ./docker-compose.yml

echo $password > mysql.password
echo 'You can find your MySQL root password in the following file mysql.password'
echo 'MySQL Password: '$password