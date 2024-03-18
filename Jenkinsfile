pipeline {
    agent {
        label 'agent193'
    }
    environment {
        DOCKER_HUB_TOKEN_CREDENTIALS = 'dockerhub_token_credentials'
        IMAGE_NAME = 'abctechnologies'
        WAR_FILE = '/var/jenkins-agent/workspace/DockerTomCatApp/target/ABCtechnologies-1.0.war'
    }
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
                sh 'docker build --progress=plain -t ${IMAGE_NAME} .'
            }
        }
        stage('Docker Login') {
            steps {
                withCredentials([string(credentialsId: DOCKER_HUB_TOKEN_CREDENTIALS, variable: 'DOCKER_TOKEN')]) {
                    sh "docker login -u _ -p ${DOCKER_TOKEN} docker.io"
                }
            }
        }
        stage('Push to DockerHub') {
            steps {
                sh "docker push ${IMAGE_NAME}"
            }
        }
        stage('Docker Logout') {
            steps {
                sh "docker logout"
            }
        }
        stage('Pull from DockerHub') {
            steps {
                sh "docker pull ${IMAGE_NAME}"
            }
        }
        stage('Run Docker Container') {
            steps {
                sh "docker run -d -p 8080:8080 --name ${IMAGE_NAME} ${IMAGE_NAME}"
            }
        }
    }
}
