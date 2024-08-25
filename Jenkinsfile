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
        stage('Checkout') {
            steps {
                script {
                    dir("terraform") {
                        checkout([
                            $class: 'GitSCM', 
                            branches: [[name: '*/main']], 
                            doGenerateSubmoduleConfigurations: false, 
                            extensions: [], 
                            submoduleCfg: [], 
                            userRemoteConfigs: [[
                                url: 'https://github.com/your-repo/Terraform-Jenkins.git',
                                credentialsId: 'github-credentials' // Use the ID of the Jenkins credentials
                            ]]
                        ])
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                script {
                    dir("terraform") {
                        // Initialize Terraform
                        sh 'terraform init'
                        // Generate a plan and output it to a file
                        sh 'terraform plan -out=tfplan'
                        // Show the plan in a readable format
                        sh 'terraform show -no-color tfplan > tfplan.txt'
                    }
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    dir("terraform") {
                        // Apply the Terraform plan to create the resources
                        if (params.autoApprove) {
                            sh 'terraform apply -input=false tfplan'
                        } else {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                            sh 'terraform apply -input=false tfplan'
                        }
                    }
                }
            }
        }

        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroyInfrastructure
            }
            steps {
                script {
                    dir("terraform") {
                        input message: "Are you sure you want to destroy the infrastructure?", ok: "Destroy"
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            cleanWs() // Clean the workspace
        }
    }
}
