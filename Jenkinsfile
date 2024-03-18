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
                    // Add Docker build steps here
                    docker.build('abctechnologies', '--progress=plain -t abctechnologies:latest .')
                }
            }
        }
    }
}
