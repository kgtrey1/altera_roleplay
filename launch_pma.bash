#!/bin/bash

docker rm --force PMA
docker run --name PMA -d -e PMA_HOST=gk91407-001.dbaas.ovh.net -e PMA_PORT=35364 -p 8080:80 phpmyadmin/phpmyadmin:latest