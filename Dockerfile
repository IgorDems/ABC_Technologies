FROM docker.io/library/ubuntu:22.04
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-21-jdk wget
RUN mkdir /usr/local/tomcat
ADD https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.0-M17/bin/apache-tomcat-11.0.0-M17.tar.gz  /tmp/apache-tomcat-11.0.0-M17.tar.gz
RUN cd /tmp &&  tar xvfz apache-tomcat-11.0.0-M17.tar.gz
RUN cp -Rv /tmp/apache-tomcat-11.0.0-M17/*  /usr/local/tomcat/
ADD **/*.war /usr/local/tomcat/webapps
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run