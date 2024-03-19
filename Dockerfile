# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Install wget, OpenJDK 17, and Apache Tomcat
RUN apt-get update && apt-get install -y \
    wget \
    openjdk-17-jdk \
    && apt-get clean

# Download and install Apache Tomcat
RUN wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.87/bin/apache-tomcat-9.0.87.tar.gz && \
    tar -xzvf apache-tomcat-9.0.87.tar.gz && \
    mv apache-tomcat-9.0.87 /opt/tomcat

# Expose port 8080
EXPOSE 8080
