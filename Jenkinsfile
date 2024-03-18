pipeline {
    agent {
        label 'agent193'
    }
    environment {
        DOCKER_IMAGE = 'abctechnologies'
        DOCKERFILE_PATH = './Dockerfile'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: 'tomcat']], userRemoteConfigs: [[url: 'https://github.com/IgorDems/ABC_Technologies.git']]])
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
                script {
                    docker.build("${env.DOCKER_IMAGE}", "--file ${env.DOCKERFILE_PATH} --progress=plain .")
                }
            }
        }
        stage('Run Container') {
            steps {
                script {
                    docker.run("${env.DOCKER_IMAGE}")
                }
            }
        }
    }
    post {
        always {
            script {
                docker.image("${env.DOCKER_IMAGE}").remove()
            }
        }
    }
}
