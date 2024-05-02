pipeline {
    agent { label 'agent193' }
    
    environment {
        DOCKERHUB_USERNAME = credentials('dockerhub_credentials').username
        DOCKERHUB_PASSWORD = credentials('dockerhub_credentials').password
    }
    
    stages {
        stage('Run Ansible Playbook') {
            steps {
                script {
                    sh 'ansible-playbook -i localhost, --extra-vars "dockerhub_username=${DOCKERHUB_USERNAME} dockerhub_password=${DOCKERHUB_PASSWORD}" ansibleK8s.yml'
                }
            }
        }
    }
}
