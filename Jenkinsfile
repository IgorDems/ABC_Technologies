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
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                ansiblePlaybook credentialsId: 'dockerhub_token_credentials', playbook: 'ansibleK8s.yml', become: true
            }
        }
    }
}
