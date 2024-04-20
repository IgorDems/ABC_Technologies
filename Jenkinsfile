pipeline {
    agent {
        label 'agent193'
    }
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'ansible-playbook -vvv docker_image.yml'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                        sh 'docker tag abctechnologies docker.io/demsdocker/abctechnologies'
                        sh 'docker push docker.io/demsdocker/abctechnologies'
                    }
                }
            }
        }
        stage('Deploy on Kubernetes') {
            steps {
                script {
                    // Assuming kubectl is installed and configured
                    sh 'kubectl apply -f /var/jenkins-agent/workspace/ABC_AnsibleK8s/'
                }
            }
        }
        stage('Integrate Ansible with Kubernetes') {
            steps {
                script {
                    // Integrate Kubernetes with Ansible here
                    sh 'ansible-playbook kubernetes.yml'
                }
            }
        }
        stage('Create Deployment and Service') {
            steps {
                script {
                    // Create deployment and service using Ansible playbook
                    sh 'ansible-playbook create_deployment_service.yml'
                }
            }
        }
    }
}
