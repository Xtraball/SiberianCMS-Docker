#!/bin/bash

case $1 in
    'start')
        docker-compose up -d
        chmod -R 775 ./siberian
    ;;
    'stop')
        docker-compose stop
    ;;
    'restart')
        docker-compose stop
        docker-compose up -d
    ;;
    'rebuild')
        docker-compose stop
        docker-compose rm
        docker-compose build
        docker-compose up -d
    ;;
esac