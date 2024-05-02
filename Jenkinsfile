pipeline {
    agent any
    environment {
        DOCKER_USERNAME = credentials('dockerhub_token_credentials').username
        DOCKER_PASSWORD = credentials('dockerhub_token_credentials').password
    }
    stages {
        stage('Deploy with Ansible') {
            steps {
                ansiblePlaybook playbook: 'ansibleK8s.yml'
            }
        }
    }
}
