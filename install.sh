#!/bin/bash

# Copy docker-compose.yml
cp -f docker-compose-template.yml docker-compose.yml
mkdir -p ./etc/ssl
chmod -R 777 ./etc/ssl

# Generates a temporary SSL certificate
openssl genrsa -des3 -passout pass:x -out ./etc/ssl/default.pass.key 2048
openssl rsa -passin pass:x -in ./etc/ssl/default.pass.key -out ./etc/ssl/default.key
rm ./etc/ssl/default.pass.key
openssl req -new -key ./etc/ssl/default.key -out ./etc/ssl/default.csr \
  -subj "/C=FR/ST=Haute-Garonne/L=Toulouse/O=Xtraball/OU=SysAdmin/CN=mysiberian.example.com"
openssl x509 -req -days 365 -in ./etc/ssl/default.csr -signkey ./etc/ssl/default.key -out ./etc/ssl/default.crt

# Generates a Random MySQL Password
if [ -s ./mysql.password ]
then
    password=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13`
    echo $password > mysql.password
else
    password=`cat ./mysql.password`
fi
sed -i'' s/MYSQL_ROOT_PASSWORD=changeme/MYSQL_ROOT_PASSWORD=$password/g ./docker-compose.yml

echo 'You can find your MySQL root password in the following file `mysql.password`'
echo 'MySQL Password: '$password