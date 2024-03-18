pipeline {
    agent {
        label 'agent193'
    }
    environment {
        DOCKER_CREDENTIALS = 'dockerhub_credentials'
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
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
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
