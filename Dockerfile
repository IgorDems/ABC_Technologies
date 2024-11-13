# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Install required packages and set up Tomcat
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget openjdk-17-jdk curl && \
    # Get the latest Tomcat 9 version dynamically
    TOMCAT_VERSION=$(curl -s https://downloads.apache.org/tomcat/tomcat-9/ | grep -o 'v9\.0\.[0-9]*' | sort -V | tail -n 1) && \
    echo "Latest Tomcat version: ${TOMCAT_VERSION}" && \
    wget "https://downloads.apache.org/tomcat/tomcat-9/${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION#v}.tar.gz" && \
    tar -xzvf apache-tomcat-*.tar.gz && \
    mv apache-tomcat-* /opt/tomcat && \
    rm -rf apache-tomcat-*.tar.gz

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
CMD ["/opt/tomcat/bin/catalina.sh", "run"]