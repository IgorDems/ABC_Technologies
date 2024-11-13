#!groovy

pipeline {
    agent {
        label 'agent193'
    }
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        DOCKER_REGISTRY = 'docker.io'
        NAMESPACE = 'abc-tech'
        APP_NAME = 'abctechnologies'
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        def dockerImage = docker.build('abctechnologies', '-f Dockerfile .')
                    } catch (Exception e) {
                        error "Failed to build Docker image: ${e.message}"
                    }
                }       
            }
        }  

        stage('Push Docker Image') {
            steps {
                script {
                    try {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', 
                                                        usernameVariable: 'DOCKER_USERNAME', 
                                                        passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh """
                                echo "Logging into DockerHub..."
                                docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                                
                                echo "Tagging image..."
                                docker tag abctechnologies $DOCKER_USERNAME/abctechnologies:latest
                                
                                echo "Pushing image..."
                                docker push $DOCKER_USERNAME/abctechnologies:latest
                            """
                        }
                    } catch (Exception e) {
                        error "Failed to push Docker image: ${e.message}"
                    }
                }
            }
        }

        stage('Verify Docker Image') {
            steps {
                script {
                    try {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', 
                                                        usernameVariable: 'DOCKER_USERNAME', 
                                                        passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh """
                                echo "Pulling latest image..."
                                docker pull ${DOCKER_USERNAME}/abctechnologies:latest
                                
                                echo "Verifying Tomcat installation..."
                                docker run --rm ${DOCKER_USERNAME}/abctechnologies:latest /opt/tomcat/bin/version.sh
                            """
                        }
                    } catch (Exception e) {
                        error "Failed to verify Docker image: ${e.message}"
                    }
                }
            }
        }

        stage('Deploy on Kubernetes') {
            steps {
                script {
                    try {
                        withKubeConfig([
                            credentialsId: 'kubernetes-ca',
                            serverUrl: 'https://10.0.0.193:6443'
                        ]) {
                            sh """
                                # Create namespace
                                kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
                                
                                # Apply RBAC
                                kubectl apply -f k8s/rbac.yml
                                
                                # Apply deployment
                                kubectl apply -f deployment.yml
                                
                                # Wait for deployment to be ready
                                echo "Waiting for deployment to be ready..."
                                kubectl rollout status deployment/abctechnologies-dep -n ${NAMESPACE} --timeout=900s
                                
                                # Verify deployment
                                echo "Verifying deployment..."
                                kubectl get deployment abctechnologies-dep -n ${NAMESPACE} -o wide
                                
                                # Check pods
                                echo "Checking pod status..."
                                kubectl get pods -n ${NAMESPACE} -l app=abc-tech-app -o wide
                                
                                # Get recent events
                                echo "Recent events:"
                                kubectl get events -n ${NAMESPACE} --sort-by=.metadata.creationTimestamp | tail -n 20
                            """
                        }
                    } catch (Exception e) {
                        // Get additional debugging information if deployment fails
                        sh """
                            kubectl describe pods -n ${NAMESPACE} -l app=abc-tech-app
                            kubectl logs -n ${NAMESPACE} -l app=abc-tech-app --all-containers --tail=100
                        """
                        error "Deployment failed: ${e.message}"
                    }
                }
            }
        }
    }
    
    post {
        failure {
            echo 'Pipeline failed! Collecting debug information...'
            sh 'kubectl get events -n abc-tech --sort-by=.metadata.creationTimestamp'
        }
        cleanup {
            sh 'docker logout'
        }
    }
}