pipeline {
    agent { label 'agent193' }

    stages {
        stage('Run Ansible Playbook') {
            steps {
                script {
                    sh 'ansible-playbook -i localhost, --connection=local ansibleK8s.yml'
                }
            }
        }
    }
}
