pipeline {
    agent {
        label 'agent193'
    }
    environment {
        DOCKER_USERNAME = credentials('dockerhub_token_credentials').username // Use single or double quotes
        DOCKER_PASSWORD = credentials('dockerhub_token_credentials').password // Use single or double quotes
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
