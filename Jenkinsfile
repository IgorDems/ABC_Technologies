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
                // Docker build command with verbose output
                sh 'docker build --progress=plain -t abctechnologies .'
            }
        }
        // stage('Push to DockerHub') {
        //     steps {
        //         // Docker push command to push image to DockerHub
        //         withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
        //             sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
        //             sh 'docker tag abctechnologies $DOCKER_USERNAME/abctechnologies'
        //             sh 'docker push $DOCKER_USERNAME/abctechnologies'
        //         }
        //     }
        // }
        // stage('Pull from DockerHub and Run') {
        //     steps {
        //         // Docker pull and run commands
        //         sh 'docker pull $DOCKER_USERNAME/abctechnologies'
        //         sh 'docker run -d --name abctechnologies-container -p 8080:8080 $DOCKER_USERNAME/abctechnologies'
        //     }
        // }
    }
}
