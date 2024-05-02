pipeline {
    agent none

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/IgorDems/ABC_Technologies.git'
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                ansiblePlaybook credentialsId: 'dockerhub_token_credentials', playbook: 'ansibleK8s.yml', become: true
            }
        }
    }
}
