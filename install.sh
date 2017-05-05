#!/bin/bash

yum install -y git docker curl wget
useradd siberian

curl -L https://github.com/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

mkdir -p /home/siberian
cd /home/siberian
git clone https://github.com/Xtraball/SiberianCMS-Docker.git ./docker