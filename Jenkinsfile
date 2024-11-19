pipeline {
    agent {
        label 'agent193'
    }
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        TOMCAT_CREDENTIALS = credentials('tomcat-credentials') // Add this credential in Jenkins
    }
    
    stages {
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }
        
        stage('Stop and Remove Docker Containers') {
            steps {
                script {
                    sh 'docker stop $(docker ps -q) || true'
                    sh 'docker rm $(docker ps -aq) || true'
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    // Delete all unused Docker images
                    sh 'docker image prune -a --force'

                    // Create tomcat-users.xml file
                    writeFile file: 'tomcat-users.xml', text: """<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
    <role rolename="manager-gui"/>
    <role rolename="manager-script"/>
    <role rolename="manager-jmx"/>
    <role rolename="manager-status"/>
    <role rolename="admin-gui"/>
    <user username="${TOMCAT_CREDENTIALS_USR}" 
          password="${TOMCAT_CREDENTIALS_PSW}" 
          roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui"/>
</tomcat-users>"""

                    // Build Docker image
                    def dockerImage = docker.build('abctechnologies', '-f Dockerfile .')

                    // Authenticate with Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                        sh "docker tag abctechnologies $DOCKER_USERNAME/abctechnologies"
                        sh "docker push $DOCKER_USERNAME/abctechnologies"
                        echo "Successfully built and uploaded to DockerHub"
                        sh "docker pull $DOCKER_USERNAME/abctechnologies"
                    }       

                    echo "Successfully pulled Docker image from DockerHub"
                    
                    // Start Docker container with Tomcat configuration
                    def dockerContainer = dockerImage.run("""
                        -d \
                        --name abctechnologies-container \
                        -p 8080:8080 \
                        -e TOMCAT_USERNAME=${TOMCAT_CREDENTIALS_USR} \
                        -e TOMCAT_PASSWORD=${TOMCAT_CREDENTIALS_PSW}
                    """)

                    def containerId = dockerContainer.id
                    
                    // Wait for Tomcat to start
                    sh "sleep 30"

                    // Verify Tomcat is running
                    sh "docker inspect --format='{{.State.Status}}' $containerId"
                    sh "docker inspect --format='{{.NetworkSettings.IPAddress}}' $containerId"
                    
                    // Test Tomcat Manager access
                    sh """
                        curl --fail \
                        -u ${TOMCAT_CREDENTIALS_USR}:${TOMCAT_CREDENTIALS_PSW} \
                        http://localhost:8080/manager/html || true
                    """
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Tomcat configuration and deployment successful'
        }
        failure {
            echo 'Tomcat configuration or deployment failed'
        }
    }
}