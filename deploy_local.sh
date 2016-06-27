#!/bin/sh

echo "┌┬┐┌─┐┌┐┌┬┌─┐┬ ┬  ┌┬┐┌─┐┬─┐┬┌┬┐┬┌┬┐┌─┐  ┌─┐┬ ┬┌┬┐┬ ┬┌─┐┬─┐┬┌┬┐┬ ┬";
echo " ││├─┤││││└─┐├─┤  │││├─┤├┬┘│ │ ││││├┤   ├─┤│ │ │ ├─┤│ │├┬┘│ │ └┬┘";
echo "─┴┘┴ ┴┘└┘┴└─┘┴ ┴  ┴ ┴┴ ┴┴└─┴ ┴ ┴┴ ┴└─┘  ┴ ┴└─┘ ┴ ┴ ┴└─┘┴└─┴ ┴  ┴ ";
#script to create and deploy all containers needed for deployment of arcticweb

#pull images and create network and containers
full () {
    #pull the latest images
    echo "Pulling latest images"
    docker pull dmadk/arcticweb
    docker pull dmadk/embryo-couchdb
    docker pull mysql
    #docker pull centurylink/watchtower

    #create a network called arcticnet
    echo "Creating network"
    docker network create arcticnet

    #create the containers and link them
    echo "Creating containers"
    # --log-opt fluentd-async-connect=true
    docker create --name arctic_db --net=arcticnet --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -p 3306:3306 -v $HOME/arcticweb/mysql/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=embryo -e MYSQL_PASSWORD=embryo -e MYSQL_DATABASE=embryo mysql

    docker create --name arctic_couch --net=arcticnet --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -p 5984:5984 -v $HOME/arcticweb/couchdb:/data dmadk/embryo-couchdb

    docker create --name arcticweb --net=arcticnet --log-driver=fluentd --link arctic_db:db --link arctic_couch:couch --log-opt fluentd-async-connect=true --restart=unless-stopped -p 8080:8080 -p 9990:9990 -v $HOME/arcticweb/properties:/opt/jboss/wildfly/arcticweb_properties -v $HOME/arcticweb:/opt/jboss/arcticweb dmadk/arcticweb

    #docker create --name arctic_watchtower --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock centurylink/watchtower arcticweb --cleanup
}

$1

# start logging
echo "Starting logging"
docker-compose -f logging/docker-compose.yml up -d

# start all containers
echo "Starting containers"
docker start arctic_db arctic_couch arcticweb

# the web administrative DOCKER UI
docker rm mgmt-Docker-UI
docker run --name mgmt-Docker-UI -d -t -p 9999:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock uifd/ui-for-docker

echo "# watchtower - disabled";
echo "# the web application (WILDFLY)                     http://localhost:8080";
echo "# the web administrative application (WILDFLY)      http://localhost:9990";
echo "# the web administrative DOCKER UI                  http://localhost:9999";
echo "# Couch DB                                          http://localhost:5984/_utils/index.html";
echo "# MYSQL localhost:3306 use desktop client like mysql workbench";
echo "# Logging user interface Kibana                     http://localhost:5601/app/kibana#/";
echo "# fluentd https://github.com/fluent/fluentd Fluentd: Open-Source Log Collector";

exit 0
