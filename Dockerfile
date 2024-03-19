FROM ubuntu:22.04

# Install necessary dependencies
RUN apt-get update && apt-get install -y wget tar

# Define environment variables
ENV TOMCAT_VERSION 11.0.12
ENV TOMCAT_MAJOR 11
ENV TOMCAT_HOME /opt/tomcat


# Retry logic for downloading Tomcat
RUN retries=5 && \
    for i in $(seq 1 $retries); do \
        wget -q "https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -O /tmp/tomcat.tar.gz && break || \
        wget -q "https://mirrors.estointernet.in/apache/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -O /tmp/tomcat.tar.gz && break || \
        sleep 20; \
    done

# Check if the download was successful
RUN [ -f "/tmp/tomcat.tar.gz" ] || (echo "Failed to download Apache Tomcat" && exit 1)

# Extract Tomcat
RUN tar xf /tmp/tomcat.tar.gz -C /opt

# Rename the directory to 'tomcat'
RUN mv /opt/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME}

# Clean up
RUN rm /tmp/tomcat.tar.gz

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["${TOMCAT_HOME}/bin/catalina.sh", "run"]
