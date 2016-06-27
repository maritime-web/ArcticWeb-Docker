#!/bin/sh

#script to create and deploy all containers needed for deployment of arcticweb

#pull images and create network and containers
full () {
    #pull the latest images
    echo "Pulling latest images"
    docker pull dmadk/arcticweb
    docker pull dmadk/embryo-couchdb
    docker pull mysql
    docker pull centurylink/watchtower

    #create a network called arcticnet
    echo "Creating network"
    docker network create arcticnet

    #create the containers and link them
    echo "Creating containers"
    docker create --name arctic_db --net=arcticnet --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -v $HOME/arcticweb/mysql/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=embryo -e MYSQL_PASSWORD=embryo -e MYSQL_DATABASE=embryo mysql

    docker create --name arctic_couch --net=arcticnet --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -v $HOME/arcticweb/couchdb:/data dmadk/embryo-couchdb

    docker create --name arcticweb --net=arcticnet --log-driver=fluentd --link arctic_db:db --link arctic_couch:couch --log-opt fluentd-async-connect=true --restart=unless-stopped -p 8080:8080 -v $HOME/arcticweb/properties:/opt/jboss/wildfly/arcticweb_properties -v $HOME/arcticweb:/opt/jboss/arcticweb dmadk/arcticweb

    docker create --name arctic_watchtower --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock centurylink/watchtower arcticweb --cleanup
}

$1

# start logging
echo "Starting logging"
docker-compose -f logging/docker-compose.yml up -d

# start all containers
echo "Starting containers"
docker start arctic_db arctic_couch arcticweb arctic_watchtower

exit 0
