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
                sh 'mvn package'
            }
        }

        stage('Docker Build and Publish') {
            environment {
                DOCKER_HUB_CREDENTIALS = credentials('dockerhub_credentials')
            }
            steps {
                script {
                    def dockerImage = 'abctechnologies'
                    def warFilePath = '/var/jenkins-agent/workspace/DockerTomCatApp/target/ABCtechnologies-1.0.war'

                    docker.build("demsdocker/${dockerImage}", "--progress=plain -t -f Dockerfile --build-arg WAR_FILE=${warFilePath} .").push()
                }
            }
        }
    }
}
