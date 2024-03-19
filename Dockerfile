# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Install Apache Tomcat
RUN apt-get update && \
    apt-get install -y default-jdk && \
    apt-get install -y wget && \
    cget https://downloads.apache.org/tomcat/tomcat-9/v9.0.59/bin/apache-tomcat-9.0.59.tar.gz && \
    tar -xvf apache-tomcat-9.0.59.tar.gz && \
    mv apache-tomcat-9.0.59 /usr/local/tomcat && \
    rm -rf apache-tomcat-9.0.59.tar.gz && \
    chmod +x /usr/local/tomcat/bin/*.sh

# Copy WAR file to Tomcat webapps directory
COPY target/ABCtechnologies-1.0.war /usr/local/tomcat/webapps/

# Expose port 8080
EXPOSE 8080
