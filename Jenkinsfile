pipeline {
    agent any

    parameters {
        string(name: 'provider', defaultValue: 'google', description: 'Do not change)
        string(name: 'resource', defaultValue: 'images', description: 'Do not change')
        string(name: 'environment', defaultValue: 'dev', description: 'Environment to deploy to')
        string(name: 'region', defaultValue: 'us-central1', description: 'Region to deploy to')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/jenkins-admin1/packer-gcp.git']])
            }
        }

        stage('Validate Packer Template') {
            steps {
                sh "cd /var/lib/jenkins/workspace/gcp-project/${params.provider}/${params.resource}/${params.environment}/${params.region}/${params.repo_name} && packer validate"
            }
        }

        stage('Build Image') {
            steps {
                sh "cd /var/lib/jenkins/workspace/gcp-project/${params.provider}/${params.resource}/${params.environment}/${params.region}/${params.repo_name} && packer build"
            }
        }

        stage('Cleanup') {
            steps {
                sh "rm -rf output-*"
            }
        }
    }
}
