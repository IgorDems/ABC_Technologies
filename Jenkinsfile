pipeline {
    agent {
        label 'agent193'
    }
    environment {
        DOCKER_USERNAME = credentials('dockerhub_token_credentials').username
        DOCKER_PASSWORD = credentials('dockerhub_token_credentials').password
    }
    stages {
        stage('Deploy with Ansible') {
            steps {
                // ansiblePlaybook playbook: 'ansibleK8s.yml'
                sh 'ansible-playbook -i localhost, --connection=local ansibleK8s.yml'
            }
        }
    }
}
