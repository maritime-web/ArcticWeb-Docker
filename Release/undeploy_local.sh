#!/bin/bash

echo "Stopping containers"
docker stop arcticweb arctic_db arctic_couch

full ()
{
    echo "Removing containers"
    docker rm arcticweb arctic_db arctic_couch
    docker-compose -f logging/docker-compose.yml down
    docker network rm arcticnet
}

$1

exit 0
