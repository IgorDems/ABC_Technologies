pipeline {
    agent {
        label 'agent193'
    }
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        DOCKER_REGISTRY = 'docker.io'
        // DOCKERHUB_CREDENTIALS = credentials('dockerhub_token_credentials')
        
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // sh 'ansible-playbook -vvv docker_image.yml --connection=local'

                    // Build Docker image
                    def dockerImage = docker.build('abctechnologies', '-f Dockerfile .')

                    // sh 'ansible-playbook -vvv ansibleK8s.yml --connection=local'



                    // Authenticate with Docker Hub
                    // withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    // sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"

                    // Tag Docker image
                    // sh "docker tag abctechnologies $DOCKER_USERNAME/abctechnologies"

                    // Push Docker image to DockerHub
                    // sh "docker push $DOCKER_USERNAME/abctechnologies"
                    // Echo success message for Docker image build and upload
                    // echo "Successfully built and uploaded to DockerHub"

                    // Pull Docker image from DockerHub
                    // sh "docker pull $DOCKER_USERNAME/abctechnologies"
            }       

                    // Echo success message for Docker image pull
                    // echo "Successfully pulled Docker image from DockerHub"
                    // Start Docker container
                    // def dockerContainer = dockerImage.run('-d --name abctechnologies-container -p 8080:8080')

                    // Get container ID
                    // def containerId = dockerContainer.id

                     // Print container status and IP
                    // sh "docker inspect --format='{{.State.Status}}' $containerId"
                    // sh "docker inspect --format='{{.NetworkSettings.IPAddress}}' $containerId"
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

                    // withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
                    //     sh 'docker -vvv login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    //     sh 'docker -vvv tag abctechnologies docker.io/demsdocker/abctechnologies'
                    //     sh 'docker -vvv push docker.io/demsdocker/abctechnologies'
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
                    sh 'kubectl apply -f /var/jenkins-agent/workspace/ABC_AnsibleK8s/deployment.yml'
                }
            }
        }

       
        // stage('Integrate Ansible with Kubernetes') {
        //     steps {
        //         script {
        //             // Integrate Kubernetes with Ansible here
        //             sh 'ansible-playbook kubernetes.yml --connection=local'
        //         }
        //     }
        // }
        stage('Create Deployment and Service') {
            steps {
                script {
                    // Create deployment and service using Ansible playbook
                    sh 'ansible-playbook -vvv create_deployment_service.yml --connection=local'
                }
            }
        }
    }
}



