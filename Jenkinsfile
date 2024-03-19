pipeline {
    agent {
        label 'agent193'
    }
    stages {
        stage('Compile') {
            steps {
                // Add compilation steps here
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                // Add test steps here
                sh 'mvn test'
            }
        }
        stage('Build') {
            steps {
                // Build the WAR file
                sh 'mvn package'
            }
        }
        stage('Docker Build') {
            steps {
                script{	
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

                    // Start Docker container
                    // def dockerContainer = dockerImage.run('-p 8080:8080')

                    // Get container ID
                    // def containerId = dockerContainer.id

                    // Print container status and IP
                    // sh "docker inspect --format='{{.State.Status}}' $containerId"
                    // sh "docker inspect --format='{{.NetworkSettings.IPAddress}}' $containerId"}
                
            }
        }
        stage('Push to DockerHub') {
            steps {
                // Docker push command to push image to DockerHub
                withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    sh 'docker tag abctechnologies $DOCKER_USERNAME/abctechnologies'
                    sh 'docker push $DOCKER_USERNAME/abctechnologies'
                }
            }
        }
        stage('Pull from DockerHub and Run') {
            steps {
                // Docker pull and run commands
                sh 'docker pull $DOCKER_USERNAME/abctechnologies'
                // Start Docker container
                def dockerContainer = dockerImage.run('-p 8080:8080')

                // Get container ID
                def containerId = dockerContainer.id

                // Print container status and IP
                sh "docker inspect --format='{{.State.Status}}' $containerId"
                sh "docker inspect --format='{{.NetworkSettings.IPAddress}}' $containerId"
                // sh 'docker run -d --name abctechnologies-container -p 8080:8080 $DOCKER_USERNAME/abctechnologies'
                }
            }
        }
    }
}
