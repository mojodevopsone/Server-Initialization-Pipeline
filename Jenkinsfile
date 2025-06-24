pipeline {
    parameters {
        string defaultValue: '255.255.255.255', name: 'ip_address', trim: true
        string defaultValue: 'root', name: 'username', trim: true
        password defaultValue: '', name: 'password'
    }

    agent any

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'jenkins-sshkey', branch: 'main', url: 'git@github.com:mojodevopsone/ansible-inventory-test.git'
            }
        }

        stage('Generate Inventory') {
            steps {
                sh '''cat << EOL > inventory.ini
[all]
${ip_address}
[all:vars]
ansible_ssh_user=${username}
ansible_ssh_password=${password}
EOL
                '''     
            }
        }

        stage('Run Ansible') {
            steps {
                ansiblePlaybook(
                    playbook: 'playbook.yml',
                    inventory: 'inventory.ini',
                    credentialsId: 'jenkins-sshkey',
                    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
                )
            }
        }
    }
}
