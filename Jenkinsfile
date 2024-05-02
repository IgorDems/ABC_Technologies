pipeline {
    agent {
        label 'agent193'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'ansiblekube', url: 'https://github.com/IgorDems/ABC_Technologies.git'
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                ansiblePlaybook credentialsId: 'dockerhub_token_credentials', playbook: 'ansibleK8s.yml', connection: 'local'
            }
        }
    }
}