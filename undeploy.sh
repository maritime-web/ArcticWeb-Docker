#!/bin/bash

echo "Stopping containers"
docker stop arcticweb arctic_db arctic_couch arctic_watchtower arctic_nginx

full ()
{
    echo "Removing containers"
    docker rm arcticweb arctic_db arctic_couch arctic_watchtower arctic_nginx
    docker-compose -f logging/docker-compose.yml down
    docker network rm arcticnet
}

$1

exit 0
