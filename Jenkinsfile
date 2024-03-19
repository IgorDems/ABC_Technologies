pipeline {
    agent { label 'agent193' }
    environment {
        DOCKER_IMAGE = 'abctechnologies'
        DOCKERFILE_PATH = './Dockerfile'
        CONTAINER_NAME = 'my-tomcat-container'
        DOCKER_HUB_CREDENTIALS = 'dockerhub_credentials'
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE, 
                        dockerfile: DOCKERFILE_PATH, 
                        buildArgs: [
                            WGET: 'installed',
                            JDK_VERSION: '17',
                            TOMCAT_VERSION: '9.0.87'
                        ],
                        additionalBuildArgs: '--progress=plain'
                    )
                }
            }
        }
        stage('Start Docker Container') {
            steps {
                script {
                    docker.image(DOCKER_IMAGE).run('-p 8080:8080 --name ${CONTAINER_NAME}')
                }
            }
        }
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
                sh 'mvn build'
            }
        }
    }
    post {
        success {
            script {
                def containerIP = sh(script: "docker inspect -f '{{.NetworkSettings.IPAddress}}' ${CONTAINER_NAME}", returnStdout: true).trim()
                echo "Container IP: $containerIP"
                echo "Tomcat URL: http://$containerIP:8080"
            }
        }

    }
}
