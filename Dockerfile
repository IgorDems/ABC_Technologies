FROM ubuntu:22.04

# Install Apache Tomcat
RUN apt-get update && apt-get install -y apache-tomcat-11.0.0-M17

# Expose port 8080
EXPOSE 8080
