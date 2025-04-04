pipeline {
    agent any
    
    environment {
        AZURE_SUBSCRIPTION_ID = '9a2083dd-e5f8-4f25-9b0b-23b06a485ddb'
        AZURE_TENANT_ID = '1320b4f6-35bd-4e24-8d0e-f08f366c4fd7'
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Yashsuman04/WebApiJenkins',
                        credentialsId: ''
                    ]]
                ])
            }
        }
        
        stage('Terraform Init') {
            steps {
                bat '''
                    terraform init -input=false
                '''
            }
        }
        
        stage('Terraform Plan') {
            steps {
                bat '''
                    terraform plan -out=tfplan -input=false
                '''
            }
        }
        
        stage('Terraform Apply') {
            steps {
                bat '''
                    terraform apply -auto-approve -input=false tfplan
                '''
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Terraform deployment completed successfully!'
        }
        failure {
            echo 'Terraform deployment failed!'
            bat '''
                terraform destroy -auto-approve
            '''
        }
    }
} 
