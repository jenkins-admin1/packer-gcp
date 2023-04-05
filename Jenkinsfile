pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/jenkins-admin1/packer-gcp.git']])
            }
        }

        stage('Validate Packer Template') {
            steps {
                sh "cd /var/lib/jenkins/workspace/packer-gcp/${params.provider}/${params.resource}/${params.environment}/${params.region}/${params.repo_name} && packer validate config.pkr.hcl"
            }
        }

        stage('Build Image') {
            steps {
                sh "cd /var/lib/jenkins/workspace/packer-gcp/${params.provider}/${params.resource}/${params.environment}/${params.region}/${params.repo_name} && packer build"
            }
        }

        stage('Cleanup') {
            steps {
                sh "rm -rf output-*"
            }
        }
    }
}
