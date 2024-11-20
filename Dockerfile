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

# Configure Tomcat users and roles
# RUN echo '<?xml version="1.0" encoding="UTF-8"?>\n\
# <tomcat-users xmlns="http://tomcat.apache.org/xml"\n\
#               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n\
#               xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"\n\
#               version="1.0">\n\
#     <role rolename="manager-gui"/>\n\
#     <role rolename="manager-script"/>\n\
#     <role rolename="manager-jmx"/>\n\
#     <role rolename="manager-status"/>\n\
#     <role rolename="admin-gui"/>\n\
#     <user username="admin" password="admin_password" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui"/>\n\
# </tomcat-users>' > /opt/tomcat/conf/tomcat-users.xml

# # Create and configure context.xml files for manager and host-manager
# RUN echo '<?xml version="1.0" encoding="UTF-8"?>\n\
# <Context antiResourceLocking="false" privileged="true" >\n\
#   <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="^.*$" />\n\
# </Context>' > /opt/tomcat/webapps/manager/META-INF/context.xml && \
#     echo '<?xml version="1.0" encoding="UTF-8"?>\n\
# <Context antiResourceLocking="false" privileged="true" >\n\
#   <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="^.*$" />\n\
# </Context>' > /opt/tomcat/webapps/host-manager/META-INF/context.xml

# # Ensure the directories exist for manager and host-manager
# RUN mkdir -p /opt/tomcat/webapps/manager/META-INF \
#     /opt/tomcat/webapps/host-manager/META-INF

COPY **/ABCtechnologies-1.0.war /opt/tomcat/webapps/

# Expose the default Tomcat port
EXPOSE 8080

# Start Apache Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]