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
                // Reference environment variable within the step
                ansiblePlaybook credentialsId: 'dockerhub_token_credentials', playbook: 'ansibleK8s.yml', become: true, extraVars: ['DOCKER_USERNAME=${ENVIRONMENT}_user', 'DOCKER_PASSWORD=${ENVIRONMENT}_password']
            }
        }
    }
}
