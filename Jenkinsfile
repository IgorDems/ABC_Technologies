pipeline {
    agent { label 'agent193' }
    stages {
        stage('Compile') {
            steps {
                 sh 'mvn compile
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Build') {
            steps {
                // Build Docker image
                script {
                    docker.build('abctechnologies', '--progress=plain -t abctechnologies:latest .')
                }
            }
        }
        stage('Run Container') {
            steps {
                // Start Docker container
                script {
                    docker.image('abctechnologies').run('-p 8080:8080')
                }
            }
        }
    }
}
