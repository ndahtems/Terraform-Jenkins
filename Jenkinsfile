pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroyInfrastructure', defaultValue: false, description: 'Destroy infrastructure after apply?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any

    stages {
        stage('checkout') {
            steps {
                script {
                    dir("terraform") {
                        git "https://github.com/rayeeta/Terraform-Jenkins.git"
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                sh 'pwd; cd terraform/ ; terraform init'
                sh 'pwd; cd terraform/ ; terraform plan -out tfplan'
                sh 'pwd; cd terraform/ ; terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                sh 'pwd; cd terraform/ ; terraform apply -input=false tfplan'
            }
        }

        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroyInfrastructure
            }
            steps {
                script {
                    input message: "Are you sure you want to destroy the infrastructure?", ok: "Destroy"
                    sh 'pwd; cd terraform/ ; terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            cleanWs()
        }
    }
}
