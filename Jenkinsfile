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
                     sh 'ansible-playbook ansible/ansibleK8s.yml --connection=local'
                    // Echo success message for Docker image pull
                    echo "Successfully pull from DockerHub and start container"
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
                                kubectl apply -f k8s/deployment.yml

                                kubectl apply -f k8s/service.yml
                                
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
    



//         stage('Deploy on Kubernetes') {
//             steps {
//                 script {
//                     // kubectl is installed and configured
//                     sh '''
//                  kubectl apply -f /var/jenkins-agent/workspace/ABC_AnsibleK8s/k8s/deployment.yml \
//                         --certificate-authority=/var/jenkins-agent/kubernetes-ca.crt \
//                         --server=https://10.0.0.193:6443
//                     '''
//         }
//     }
// }


        
        // stage('Deploy on Kubernetes') {
        //     steps {
        //         script {
        //             // kubectl is installed and configured
        //             sh 'kubectl apply -f /var/jenkins-agent/workspace/ABC_AnsibleK8s/k8s/deployment.yml'
        //         }
        //     }
        // }
    
    }
}



