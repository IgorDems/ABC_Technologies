pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/IgorDems/ABC_Technologies.git'
            }
        }

        stage('Build') {
            steps {
                
                bat 'mvn clean compile test package'
            }
        }
    }

    post {
        success {
            
            echo 'Build successful!'
        }
        failure {
            
            echo 'Build failed!'
        }
    }
}
