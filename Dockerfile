FROM ubuntu:22.04

# Install Apache Tomcat 11
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://archive.apache.org/dist/tomcat/tomcat-11/v11.0.0-M17/bin/apache-tomcat-11.0.0-M17.tar.gz && \
    tar -zxvf apache-tomcat-11.0.0-M17.tar.gz -C /opt && \
    rm apache-tomcat-11.0.0-M17.tar.gz

# Deploy WAR file
COPY /var/jenkins-agent/workspace/AppABC_TomCat_DockerImage/target/ABCtechnologies-1.0.war /opt/apache-tomcat-11.0.0-M17/webapps/

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["/opt/apache-tomcat-11.0.0-M17/bin/catalina.sh", "run"]