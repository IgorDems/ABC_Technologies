#!groovy

pipeline {
    agent {
        label 'agent193'
    }
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        DOCKER_REGISTRY = 'docker.io'
                
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    def dockerImage = docker.build('abctechnologies', '-f Dockerfile .')
                }       
            }
        }  
        stage('Push Docker Image') {
            steps {
                script {
                    // Authenticate with Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    // Tag Docker image
                    sh "docker tag abctechnologies $DOCKER_USERNAME/abctechnologies"
                    // Push Docker image to DockerHub
                    sh "docker push $DOCKER_USERNAME/abctechnologies"
                    // Echo success message for Docker image build and upload
                    echo "Successfully built and uploaded to DockerHub"
                    }
                }
            }
        }
        stage('Pull Docker Image and start Docker container') {
            steps {
                script {
                     sh 'ansible-playbook ansibleK8s.yml --connection=local'
                    // Echo success message for Docker image pull
                    echo "Successfully pull from DockerHub and start container"
                }
            }
        }
        
        stage('Deploy on Kubernetes') {
            steps {
                script {
                    withKubeConfig([
                        credentialsId: 'kubernetes-ca',  // Using the credential ID you mentioned
                        serverUrl: 'https://10.0.0.193:6443'
                    ]) {
                        // Create namespace if it doesn't exist
                        sh 'kubectl create namespace abc-tech --dry-run=client -o yaml | kubectl apply -f -'
                        
                        // Apply RBAC configurations
                        sh 'kubectl apply -f k8s/rbac.yml'
                        
                        // Apply deployment
                        sh 'kubectl apply -f deployment.yml'
                        
                        // Wait for deployment
                        sh '''
                            kubectl rollout status deployment/abctechnologies-dep \
                                -n abc-tech \
                                --timeout=300s
                        '''
                    }
                }
            }
        }
        
        stage('Test Kubernetes Connection') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubernetes-ca', serverUrl: 'https://10.0.0.193:6443']) {
                        sh 'kubectl get nodes'
            }
        }
    }
}
    }
}



