# ArcticWeb Docker
A dockerized container for the ArcticWeb project. The container deploys the latest successful build of ArcticWeb on a Wildfly 8.2.0 web server. It also has the required CouchDB and MySQL as described in the [ArcticWeb](https://github.com/maritime-web/ArcticWeb#arcticweb) guide.

## Prerequisties
* Docker 1.10.0+
* Docker Compose 1.6.0+
* A file called arcticweb.properties

## Initial Setup
Clone the repository to a choosen directory using

    $ git clone https://github.com/maritime-web/ArcticWeb-Docker.git

In your home directory you need to make two new directories - 'properties' and 'arcticCouch'. The latter needs to have the subdirectory 'couchdb/etc/local.d'.
In the 'properties' directory you should put the 'arcticweb.properties' file, and in 'arcticCouch/couchdb/etc/local.d' you should put the configuration files you wish to use for the CouchDB.

If you want to build the ArcticWeb container yourself - you only need to do this if you have a specific reason to do so

    $ docker build -t dmadk/arcticweb .

Currently there are two ways of starting the ArcticWeb container and the two databases.
The first is using Docker Compose. On the first startup do

    $ docker-compose up

On subsequent startups you can start the container with either

    $ docker-compose up

Or

    $ docker-compose start

To stop use either

	  $ docker-compose stop

Or

  	$ docker-compose down

The second way of starting is using the script deploy.sh which also makes a [WatchTower](https://github.com/CenturyLinkLabs/watchtower#watchtower) container which makes sure that you are always running the latest version of BalticWeb.
On the first startup using this method do

  	$ chmod +x deploy.sh
  	$ chmod +x undeploy.sh
  	$ ./deploy.sh full

On subsequent startups do

  	$ ./deploy.sh

When you want to stop the containers do

  	$ ./undeploy.sh

If you want to stop the containers and then remove them do

  	$ ./undeploy.sh full

There is also the possibility of a doing a local deployment which doesn't create a WatchTower container and opens ports for databases and admin interface. 
