pipeline {
    agent {
        label 'agent193'
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
            }

                    // Stop and remove any existing Docker container based on 'abctechnologies' image
                    sh "docker stop abctechnologies-container || true"
                    sh "docker rm abctechnologies-container || true"

                    // Pull Docker image from DockerHub
                    sh "docker pull $DOCKER_USERNAME/abctechnologies"

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
}
