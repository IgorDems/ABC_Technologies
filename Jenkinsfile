pipeline {
    agent {
        label 'agent193'
    }
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        TOMCAT_CREDENTIALS = credentials('tomcat-credentials')
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

                    // Build Docker image
                    def dockerImage = docker.build('abctechnologies', '-f Dockerfile .')

                    // Authenticate with Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', 
                                                    usernameVariable: 'DOCKER_USERNAME', 
                                                    passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                            docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                            docker tag abctechnologies ${DOCKER_USERNAME}/abctechnologies
                            docker push ${DOCKER_USERNAME}/abctechnologies
                        """
                        echo "Successfully built and uploaded to DockerHub"
                        
                        // Pull the image
                        sh "docker pull ${DOCKER_USERNAME}/abctechnologies"
                        echo "Successfully pulled Docker image from DockerHub"
                        
                        // Run the container with proper arguments
                        sh """
                            docker run -d \
                                --name abctechnologies-container \
                                -p 8080:8080 
                        """        
                                // -e TOMCAT_USERNAME=${TOMCAT_CREDENTIALS_USR} \
                                // -e TOMCAT_PASSWORD=${TOMCAT_CREDENTIALS_PSW} \
                                // ${DOCKER_USERNAME}/abctechnologies
                        
                        
                        // Wait for Tomcat to start
                        sh 'sleep 30'
                        
                        // Get container ID of the newly created container
                        def containerId = sh(script: 'docker ps -q -l', returnStdout: true).trim()
                        
                        // Verify container is running
                        sh """
                            docker inspect --format='{{.State.Status}}' ${containerId}
                            docker inspect --format='{{.NetworkSettings.IPAddress}}' ${containerId}
                        """
                        
                        // Test Tomcat Manager access
                        // withCredentials([usernamePassword(credentialsId: 'tomcat-credentials', 
                        //                                 usernameVariable: 'TOMCAT_USER', 
                        //                                 passwordVariable: 'TOMCAT_PASSWORD')]) {
                            // sh """
                            //     curl --fail --silent \
                            //         --user ${TOMCAT_USER}:${TOMCAT_PASSWORD} \
                            //         http://localhost:8080/manager/html || true
                            // """
                        }
                    }
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