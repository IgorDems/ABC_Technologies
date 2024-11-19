pipeline {
    agent {
        label 'agent193'
    }
    
    tools {
        maven 'Maven'
    }
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
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
                    // Stop all running Docker containers
                    sh 'docker stop $(docker ps -q) || true'
                    
                    // Remove all stopped Docker containers
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
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"

                        // Tag Docker image
                        sh "docker tag abctechnologies $DOCKER_USERNAME/abctechnologies"

                        // Push Docker image to DockerHub
                        sh "docker push $DOCKER_USERNAME/abctechnologies"
                        
                        // Echo success message for Docker image build and upload
                        echo "Successfully built and uploaded to DockerHub"
                        
                        // Pull Docker image from DockerHub
                        sh "docker pull $DOCKER_USERNAME/abctechnologies"
                    }       

                    // Echo success message for Docker image pull
                    echo "Successfully pulled Docker image from DockerHub"
                    
                    // Start Docker container
                    def dockerContainer = dockerImage.run('-d --name abctechnologies-container -p 8080:8080')

                    // Get container ID
                    def containerId = dockerContainer.id

                    // Print container status and IP
                    sh "docker inspect --format='{{.State.Status}}' $containerId"
                    sh "docker inspect --format='{{.NetworkSettings.IPAddress}}' $containerId"
                }
            }
        }
    }
    
    post {
        always {
            // Post-build Maven goals
            sh 'mvn clean install site'
        }
        success {
            echo 'Post-build Maven goals executed successfully'
        }
        failure {
            echo 'Post-build Maven goals failed'
        }
    }
}