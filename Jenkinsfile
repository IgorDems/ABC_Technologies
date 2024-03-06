pipeline {
    agent any
    stages {
		stage('Test') { 
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
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') { 
            steps {
                sh 'mvn test' 
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml' 
                }
            }
        }
    }
}