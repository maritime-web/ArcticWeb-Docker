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

To start the container execute the following command
    
    $ docker-compose up

On subsequent startups you can start the container with either

    $ docker-compose up

Or

    $ docker-compose start
