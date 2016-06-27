#!/bin/bash

echo "Stopping containers"
docker stop arcticweb arctic_db arctic_couch

full ()
{
    echo "Removing containers"
    docker rm arcticweb arctic_db arctic_couch
    docker network rm arcticnet
    docker-compose -f logging/docker-compose.yml down
}

$1

exit 0
