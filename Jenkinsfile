pipeline {
    agent {
        label 'agent193'
    }
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        DOCKER_REGISTRY = 'docker.io'
        APP_NAME = 'abctechnologies'
        DOCKER_IMAGE = "demsdocker/${APP_NAME}"
        KUBE_CONFIG = credentials('kubernetes-config')
        ANSIBLE_VAULT_PASSWORD = credentials('ansible-vault-password')
        // Define environment-specific variables
        DEPLOY_ENV = "${params.ENVIRONMENT ?: 'development'}"
    }
    
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['development', 'production'], description: 'Deployment Environment')
        string(name: 'VERSION', defaultValue: '', description: 'Version to deploy (defaults to BUILD_NUMBER if empty)')
    }
    
    stages {
        stage('Initialize') {
            steps {
                script {
                    // Set version
                    env.VERSION = params.VERSION ?: env.BUILD_NUMBER
                    // Create version tag
                    env.IMAGE_TAG = "${env.VERSION}-${env.BUILD_NUMBER}"
                }
            }
        }
        
        stage('Build Application') {
            steps {
                script {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Run Tests') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'mvn test'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh 'mvn verify -DskipUnitTests'
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}", "-f Dockerfile .")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', 
                                                    usernameVariable: 'DOCKER_USERNAME', 
                                                    passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                            echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
                            docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Write Ansible vault password to file
                    writeFile file: '.vault_pass', text: "${ANSIBLE_VAULT_PASSWORD}"
                    
                    // Run Ansible playbook
                    sh """
                        ansible-playbook ansible/k8s-deploy.yml \
                            -e @ansible/vars/k8s-vars.yml \
                            -e @ansible/vars/vault.yml \
                            -e "environment=${DEPLOY_ENV}" \
                            -e "image_tag=${IMAGE_TAG}" \
                            --vault-password-file .vault_pass
                    """
                    
                    // Clean up vault password file
                    sh 'rm -f .vault_pass'
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    sh """
                        kubectl --kubeconfig=${KUBE_CONFIG} \
                            wait --for=condition=available \
                            --timeout=300s \
                            deployment/${APP_NAME}-dep \
                            -n abc-tech-${DEPLOY_ENV}
                    """
                }
            }
        }
    }
    
    post {
        success {
            script {
                // Tag successful deployment in Git
                sh """
                    git tag -a v${VERSION} -m "Version ${VERSION} deployed to ${DEPLOY_ENV}"
                    git push origin v${VERSION}
                """
            }
        }
        always {
            // Clean up Docker images
            sh """
                docker rmi ${DOCKER_IMAGE}:${IMAGE_TAG} || true
                docker system prune -f
            """
            
            // Send notification
            emailext (
                subject: "Pipeline ${currentBuild.result}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """
                    Build Status: ${currentBuild.result}
                    Build Number: ${env.BUILD_NUMBER}
                    Build URL: ${env.BUILD_URL}
                    Environment: ${DEPLOY_ENV}
                    Version: ${VERSION}
                """,
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
    }
}