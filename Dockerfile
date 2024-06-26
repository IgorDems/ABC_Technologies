# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Install wget, openjdk-17-jdk, and apache-tomcat-9.0.87
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y openjdk-17-jdk && \
    wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.88/bin/apache-tomcat-9.0.88-deployer.tar.gz && \
    tar -xzvf apache-tomcat-9.0.88.tar.gz && \
    mv apache-tomcat-9.0.88 /opt/tomcat && \
    rm -rf apache-tomcat-9.0.88.tar.gz

COPY **/ABCtechnologies-1.0.war /opt/tomcat/webapps/

# Expose port 8080
EXPOSE 8080

# Start Apache Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]