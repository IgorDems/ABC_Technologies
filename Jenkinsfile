pipeline {
    agent { label 'agent193' }

    stages {
        stage('Compile') {
            steps {
                // Add compilation steps here
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                // Add testing steps here
                sh 'mvn test'
            }
        }
        stage('Build') {
            steps {
                // Add building steps here
                sh 'mvn package'
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    docker.build('demsdocker/abctechnologies:latest', '-f Dockerfile .')
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credentials') {
                        docker.image('demsdocker/abctechnologies:latest').push()
                    }
                }
            }
        }
        stage('Pull & Run Docker Container') {
            steps {
                sh 'docker pull demsdocker/abctechnologies:latest'
                sh 'docker run -d -p 8080:8080 --name abctechnologies-container demsdocker/abctechnologies:latest'
            }
        }
    }
}
