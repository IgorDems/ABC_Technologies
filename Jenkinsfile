pipeline {
    agent {
        label 'agent193'
    }
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        // DOCKERHUB_CREDENTIALS = credentials('dockerhub_token_credentials')
        
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'ansible-playbook -vvv docker_image.yml --connection=local'
                    }
                }
            }
            
        
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
                        sh 'docker -vvv login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                        sh 'docker -vvv tag abctechnologies docker.io/demsdocker/abctechnologies'
                        sh 'docker -vvv push docker.io/demsdocker/abctechnologies'
                    }
                }
            }
        }
        // stage('Push Docker Image') {
        //     steps {
        //         script {
        //             withCredentials([string(credentialsId: 'dockerhub_token_credentials', variable: 'DOCKERHUB_TOKEN')]) {
        //                 docker.withRegistry("${DOCKER_REGISTRY}", "dockerhub_token_credentials") {
        //                     def customImage = docker.build("abctechnologies")
        //                     customImage.push()
        //                 }
        //             }
        //         }
        //     }
        // }
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
                    sh 'ansible-playbook kubernetes.yml --connection=local'
                }
            }
        }
        stage('Create Deployment and Service') {
            steps {
                script {
                    // Create deployment and service using Ansible playbook
                    sh 'ansible-playbook create_deployment_service.yml --connection=local'
                }
            }
        }
    }
}

