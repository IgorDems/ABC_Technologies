FROM ubuntu:22.04

# Install Apache Tomcat
RUN apt-get update && apt-get install -y wget && \
    wget https://downloads.apache.org/tomcat/tomcat-11/v11.0.0-M17/bin/apache-tomcat-11.0.0-M17.tar.gz && \
    tar -xzf apache-tomcat-11.0.0-M17.tar.gz && \
    mv apache-tomcat-11.0.0-M17 /opt/tomcat && \
    rm apache-tomcat-11.0.0-M17.tar.gz

# Set environment variables
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Add the war file to webapps directory
ARG WAR_FILE
ADD $WAR_FILE $CATALINA_HOME/webapps/

# Expose port 8080
EXPOSE 8080
