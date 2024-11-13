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

        stage('Verify Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                            docker pull ${DOCKER_USERNAME}/abctechnologies:latest
                            docker run --rm ${DOCKER_USERNAME}/abctechnologies:latest /opt/tomcat/bin/version.sh
                        """
            }
        }
    }
}


        // stage('Pull Docker Image and start Docker container') {
        //     steps {
        //         script {
        //              sh 'ansible-playbook ansibleK8s.yml --connection=local'
        //             // Echo success message for Docker image pull
        //             echo "Successfully pull from DockerHub and start container"
        //         }
        //     }
        // }
        


        stage('Deploy on Kubernetes') {
    steps {
        script {
            withKubeConfig([
                credentialsId: 'kubernetes-ca',
                serverUrl: 'https://10.0.0.193:6443'
            ]) {
                echo "=Create namespace if it doesn't exist="
                sh 'kubectl create namespace abc-tech --dry-run=client -o yaml | kubectl apply -f -'
                
                echo "=Apply RBAC configurations="
                sh 'kubectl apply -f k8s/rbac.yml'
                
                echo "=Apply deployment="
                sh 'kubectl apply -f deployment.yml'
                
                // Add debugging steps
                sh '''
                    echo "=== Checking pods status ==="
                    kubectl get pods -n abc-tech
                    
                    echo "=== Checking deployment status ==="
                    kubectl describe deployment abctechnologies-dep -n abc-tech
                    
                    echo "=== Checking pod logs ==="
                    for pod in $(kubectl get pods -n abc-tech -l app=abc-tech-app -o jsonpath='{.items[*].metadata.name}'); do
                        echo "=== Logs for $pod ==="
                        kubectl logs $pod -n abc-tech
                    done
                    
                    echo "=== Checking pod events ==="
                    kubectl get events -n abc-tech --sort-by=.metadata.creationTimestamp
                    
                    echo "=== Waiting for deployment ==="
                    kubectl rollout status deployment/abctechnologies-dep \
                        -n abc-tech \
                        --timeout=600s
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



