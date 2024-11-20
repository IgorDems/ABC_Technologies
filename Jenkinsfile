pipeline {
    agent any
    
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
        
        stage('Stop and Remove Docker Containers') {
            steps {
                script {
                    sh '''
                        docker ps -q | xargs -r docker stop
                        docker ps -aq | xargs -r docker rm
                    '''
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    // Clean up old images
                    sh 'docker image prune -a --force'
                    
                    // Build new image
                    docker.build("abctechnologies")
                    
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // Login to DockerHub
                        sh 'docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}'
                        
                        // Tag and push the image
                        sh 'docker tag abctechnologies demsdocker/abctechnologies'
                        sh 'docker push demsdocker/abctechnologies'
                        echo 'Successfully built and uploaded to DockerHub'
                        
                        // Pull and run the image
                        sh 'docker pull demsdocker/abctechnologies'
                        echo 'Successfully pulled Docker image from DockerHub'
                        
                        // Run the container with proper image name and Tomcat configuration
                        sh '''
                            docker run -d \
                                --name abctechnologies-container \
                                -p 8080:8080 \
                                demsdocker/abctechnologies \
                                /opt/tomcat/bin/catalina.sh run
                        '''
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        failure {
            echo 'Tomcat configuration or deployment failed'
        }
    }
}