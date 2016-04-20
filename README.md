# ArcticWeb Docker
A dockerized container for the ArcticWeb project. The container deploys the latest successful build of ArcticWeb on a Wildfly 8.2.0 web server. It also has the required CouchDB and MySQL as described in the [ArcticWeb](https://github.com/maritime-web/ArcticWeb#arcticweb) guide. 

## Prerequisties
* Docker 1.10.0+
* Docker Compose 1.6.0+
* A file called arcticweb.properties

## Initial Setup
Clone the repository to a choosen directory using

    $ git clone https://github.com/maritime-web/ArcticWeb-Docker.git

In your home directory you need to make two new directories - 'properties' and 'arcticCouch'. The latter needs to have the subdirectory 'couchdb/etc/etc/local.d'.
In the 'properties' directory you should put the 'arcticweb.properties' file, and in 'arcticCouch' in the former specified subdirectory you should put the configuration files for the CouchDB.

Then build the container using Docker Compose

    $ docker-compose build

On the first run you need to start the two databases before ArcticWeb

    $ docker-compose up mysqldb couchdb

The CouchDB should start relatively fast and when the MySQL is ready you can start ArcticWeb 
    
    $ docker-compose up

On subsequent startups you can start the entire database with the following

    $ docker-compose up

Or

    $ docker-compose start
