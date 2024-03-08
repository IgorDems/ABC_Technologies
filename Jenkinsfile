pipeline {

    agent any
	//{
    //    label 'agent191' // Replace 'your-node-label' with the actual label of your agent
    //}

//    environment {
//       MAVEN_HOME = '/path/to/your/maven'
//        PATH = "$MAVEN_HOME/bin:$PATH"
//    }

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
                sh 'mvn clean compile'
            }
        }
		
		
		stage('Test') {
            steps {
                // Use Maven to compile, test, and package the application
                sh 'mvn test'
            }
        }

        stage('Build') {
            steps {
                // Use Maven to compile, test, and package the application
                sh 'mvn package'
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
