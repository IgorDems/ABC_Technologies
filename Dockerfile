FROM ubuntu:22.04

# Install Apache Tomcat 11
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://downloads.apache.org/tomcat/tomcat-11/v11.0.0-M17/bin/apache-tomcat-11.0.0-M17.tar.gz && \
    tar -xzvf apache-tomcat-11.0.0-M17.tar.gz && \
    mv apache-tomcat-11.0.0-M17 /opt/tomcat && \
    rm apache-tomcat-11.0.0-M17.tar.gz

# Copy and deploy WAR file to Tomcat
COPY /var/jenkins-agent/workspace/DockerTomCatApp/target/ABCtechnologies-1.0.war /opt/tomcat/webapps/

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat server
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
