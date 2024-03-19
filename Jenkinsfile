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
