pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')  // Jenkins credential with AWS Access Key
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key') // Jenkins credential with AWS Secret Key
        AWS_DEFAULT_REGION    = 'us-west-2'  // Change to your desired region
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your repository
                git 'https://github.com/rayeeta/Terraform-Jenkins.git'  // Change to your repo
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    sh '''
                    terraform init
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Run Terraform plan
                    sh '''
                    terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the Terraform configuration with auto-approval
                    sh '''
                    terraform apply -auto-approve tfplan
                    '''
                }
            }
        }
    }

    post {
        always {
            // Cleanup Terraform state files, if desired
            sh '''
            terraform destroy -auto-approve
            '''
        }

        success {
            echo 'EKS cluster provisioned successfully!'
        }

        failure {
            echo 'EKS cluster provisioning failed.'
        }
    }
}

