pipeline {
    agent { label 'agent193' }

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
                script {
				
					// Check if container based on 'abctechnologies' image exists
                    def existingContainerId = sh(script: "docker ps -q --filter ancestor=abctechnologies", returnStdout: true).trim()

                    // If container exists, stop and remove it
                    if (existingContainerId != '') {
                        sh "docker stop $existingContainerId"
                        sh "docker rm $existingContainerId"
						sh "docker rmi $(docker images --filter 'dangling=true' -q --no-trunc)"
                    }
                    // Build Docker image
                    def dockerImage = docker.build('abctechnologies', '-f Dockerfile .')

                    // Start Docker container
                    def dockerContainer = dockerImage.run('-p 8080:8080')

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