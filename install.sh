#!/bin/bash

# Functions
function promptconfig {
    read -p "How much RAM would you like to dedicate to Siberian Database ? (in GB, default: 1): " DB_DRAM
    DB_DRAM=${DB_DRAM:-1}
    read -p "What should be the HTTP listening port ? (default: 8080): " HTTP_PORT
    HTTP_PORT=${HTTP_PORT:-8080}
    read -p "What should be the HTTPS listening port ? (default: 8443): " HTTPS_PORT
    HTTPS_PORT=${HTTPS_PORT:-8443}
    read -p "What range would you like to use for SocketIO ? (default: 35500-35505): " SOCKETIO_RANGE
    SOCKETIO_RANGE=${SOCKETIO_RANGE:-35500-35505}
}

# Configure
ERASE="n"
if [[ -f "./mysql.password" && -s "./mysql.password" ]]
then
    read -e -p "Your system is already initialized, would you like to erase/replace your configuration ? [Y/n]: " ERASE
    ERASE=${ERASE:-n}
    if [ "$ERASE" == "Y" ]
    then
        promptconfig
    fi
else
    ERASE="Y"
    promptconfig
fi

if [ "$ERASE" == "Y" ]
then
    # Copy docker-compose.yml
    cp -f docker-compose-template.yml docker-compose.yml
    mkdir -p ./etc/ssl
    chmod -R 777 ./etc/ssl
    if [ ! -f "./msyql" ]
    then
        mkdir ./mysql
    fi
    chmod 777 ./mysql

    # Generates a temporary SSL certificate
    openssl genpkey -algorithm RSA -out ./etc/ssl/default.pass.key -pass pass:x -pkeyopt rsa_keygen_bits:2048 -pkeyopt rsa_keygen_pubexp:3
    openssl rsa -passin pass:x -in ./etc/ssl/default.pass.key -out ./etc/ssl/default.key
    rm ./etc/ssl/default.pass.key
    openssl req -new -key ./etc/ssl/default.key -out ./etc/ssl/default.csr \
      -subj "/C=FR/ST=Haute-Garonne/L=Toulouse/O=Xtraball/OU=SysAdmin/CN=mysiberian.example.com"
    openssl x509 -req -days 365 -in ./etc/ssl/default.csr -signkey ./etc/ssl/default.key -out ./etc/ssl/default.crt

    # Generates a Random MySQL Password
    if [[ -f "./mysql.password" && -s "./mysql.password" ]]
    then
        MYSQL_PASSWORD=`cat ./mysql.password`
    else
        MYSQL_PASSWORD=`openssl rand -hex 13`
        echo $MYSQL_PASSWORD > mysql.password
    fi

    # MySQL, HTTP(S), SocketIO ports
    sed -e s/MYSQL_ROOT_PASSWORD=changeme/MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD/g \
        -e s/HTTP_PORT/$HTTP_PORT/g \
        -e s/HTTPS_PORT/$HTTPS_PORT/g \
        -e s/SOCKETIO_RANGE/$SOCKETIO_RANGE/g \
        ./docker-compose-template.yml > docker-compose.yml

    # MariaDB InnoDB Pool
    sed -e s/DB_DRAM/$DB_DRAM"G"/g \
        ./assets/mysql/conf.d/innodb.template.cnf > ./assets/mysql/conf.d/innodb.cnf

fi

echo 'You can find your MySQL root password in the following file `mysql.password`'
echo 'MySQL Password: '$MYSQL_PASSWORD
echo ''
echo 'Your configuration is done.'
echo ''

# Configure
read -e -p "Would you like to start your docker containers now ? [Y/n]: " START
START=${ERASE:-n}
if [ "$START" == "Y" ]
then
    docker-compose up -d
else
    echo "You can start your docker with 'docker-compose up -d'"
fi
