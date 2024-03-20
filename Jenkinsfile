pipeline {
    agent {
        label 'agent193'
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
                    // Check if container based on 'abctechnologies' image exists
                    def existingContainerId = sh(script: "docker ps -q --filter ancestor=abctechnologies", returnStdout: true).trim()

                    // If container exists, stop and remove it
                    if (existingContainerId != '') {
                        sh "docker stop $existingContainerId"
                        sh "docker rm $existingContainerId"
                    }

                    // Delete all unused Docker images
                    sh 'docker image prune -a --force'

                    // Build Docker image
                    def dockerImage = docker.build('abctechnologies', '-f Dockerfile .')

                    // Push Docker image to DockerHub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                        sh "docker tag abctechnologies $DOCKER_USERNAME/abctechnologies"
                        sh "docker push $DOCKER_USERNAME/abctechnologies"
                    }

                    // Pull and run Docker image from DockerHub
                    sh "docker pull $DOCKER_USERNAME/abctechnologies"
                    sh "docker run -d --name abctechnologies-container -p 8080:8080 $DOCKER_USERNAME/abctechnologies"
                }
            }
        }
        stage('Start Apache Tomcat') {
            steps {
                    sh 'sudo bash /opt/tomcat/bin/startup.sh'
                    sh 'docker exec -d abctechnologies-container /opt/tomcat/bin/startup.sh'
    }
}

    }
}
