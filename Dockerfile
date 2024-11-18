# Use a base Ubuntu image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Create the directory for Tomcat
RUN mkdir -p /opt/tomcat

# Install required packages and set up Tomcat
RUN apt-get update && \
    apt-get install -y wget openjdk-17-jdk curl && \
    # Get the latest Tomcat 9 version dynamically
    TOMCAT_VERSION=$(curl -s https://downloads.apache.org/tomcat/tomcat-9/ | grep -o 'v9\.0\.[0-9]*' | sort -V | tail -n 1) && \
    echo "Latest Tomcat version: ${TOMCAT_VERSION}" && \
    wget "https://downloads.apache.org/tomcat/tomcat-9/${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION#v}.tar.gz" && \
    tar -xzvf apache-tomcat-*.tar.gz -C /opt/tomcat --strip-components=1 && \
    rm -rf apache-tomcat-*.tar.gz && \
    # Make the scripts executable
    chmod +x /opt/tomcat/bin/*.sh

# Set environment variables
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

COPY **/ABCtechnologies-1.0.war /opt/tomcat/webapps/
# Expose the default Tomcat port
EXPOSE 8080

# Start Apache Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]