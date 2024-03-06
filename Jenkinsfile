pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your version control system (e.g., Git)
                git 'https://github.com/IgorDems/ABC_Technologies.git'
            }
        }
		
		stage('Compile') {
            steps {
                // Use Maven to compile, test, and package the application
                bat 'mvn clean compile'
            }
        }
		
		stage('Test') {
            steps {
                // Use Maven to compile, test, and package the application
                bat 'mvn test'
            }
        }
    }

    post {
        success {
            // Add steps to be executed after a successful build
            echo 'Build successful!'
        }
        failure {
            // Add steps to be executed if the build fails
            echo 'Build failed!'
        }
    }
}