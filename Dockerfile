# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install OpenJDK 21
RUN apt-get update && apt-get install -y openjdk-17-jdk

# Install Apache Tomcat 11
# You can adjust the version as needed
ENV TOMCAT_VERSION 11.0.13
RUN apt-get install -y wget && \
    wget -q https://archive.apache.org/dist/tomcat/tomcat-11/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar -xf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt && \
    mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
    rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Deploy WAR file to Tomcat
COPY ./target/ABCtechnologies-1.0.war /opt/tomcat/webapps/

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
