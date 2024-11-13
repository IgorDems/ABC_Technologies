# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Install wget, openjdk-17-jdk, and apache-tomcat-9.0.96
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget openjdk-17-jdk && \
    wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz && \
    tar -xzvf apache-tomcat-9.0.96.tar.gz && \
    mv apache-tomcat-9.0.96 /opt/tomcat && \
    rm -rf apache-tomcat-9.0.96.tar.gz

# Set CATALINA_HOME
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Create tomcat user
RUN groupadd -r tomcat && \
    useradd -r -g tomcat -d $CATALINA_HOME -s /bin/false tomcat && \
    chown -R tomcat:tomcat $CATALINA_HOME

COPY **/ABCtechnologies-1.0.war $CATALINA_HOME/webapps/

# Expose port 8080
EXPOSE 8080

# Switch to tomcat user
USER tomcat

# Start Apache Tomcat
CMD ["catalina.sh", "run"]