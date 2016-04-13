FROM jboss/wildfly:10.0.0.Final

# need root to install dependencies
USER root

RUN yum install -y epel-release

RUN yum install -y nodejs npm --enablerepo=epel

RUN npm install grunt

USER jboss

RUN /opt/jboss/wildfly/bin/add-user.sh admin admin --silent

COPY standalone_v10.xml /opt/jboss/wildfly/standalone/configuration/standalone.xml

COPY mysql-connector-java-5.1.30-bin.jar /opt/jboss/wildfly/modules/com/mysql/main/mysql-connector-java-5.1.30-bin.jar

COPY module.xml /opt/jboss/wildfly/modules/com/mysql/main/module.xml

#RUN curl -o /opt/jboss/wildfly/standalone/deployments/arctic-web.war https://dma.ci.cloudbees.com/job/ArcticWeb-branch-master/lastSuccessfulBuild/dk.dma.enav.arcticweb$arcticweb/artifact/dk.dma.enav.arcticweb/arcticweb/2.6-SNAPSHOT/arcticweb-2.6-SNAPSHOT.war

RUN ls -la /opt/jboss/wildfly/standalone/deployments

#COPY mysql-connector-java-5.1.30-bin.jar /opt/jboss/wildfly/standalone/deployments/mysql-connector-java-5.1.30-bin.jar

# VOLUME /opt/jboss/wildfly/balticweb_properties

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
