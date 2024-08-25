# Terraform-Jenkins
Terraform-Jenkins

# Jenkinsfile explained in details

Let's break down the provided Jenkinsfile, which defines a Jenkins pipeline for working with Terraform. This pipeline leads through various stages to manage infrastructure using infrastructure as code. Below is a detailed explanation of each component in the pipeline:

### Pipeline Structure

1. *Parameters Block*
   groovy
   parameters {
       booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
   }
   
   - This block allows for the definition of parameters that can be passed to the pipeline run. In this case, it defines a single boolean parameter called autoApprove.
   - If autoApprove is set to true, the Apply stage will run without waiting for manual approval. The default value is set to false.

2. *Environment Block*
   groovy
   environment {
       AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
       AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
   }
   
   - This block defines environment variables that are needed for the pipeline.
   - It uses Jenkins' credentials() function to securely fetch AWS access keys, which are likely required for any AWS-related operations in Terraform.

3. *Agent Declaration*
   groovy
   agent any
   
   - This line tells Jenkins to run the pipeline on any available agent. This could be any executor configured in your Jenkins instance.

### Stages of the Pipeline

1. *Stage: Checkout*
   groovy
   stage('checkout') {
       steps {
           script {
               dir("terraform") {
                   git "https://github.com/rayeeta/Terraform-Jenkins.git"
               }
           }
       }
   }
   
   - This stage checks out a specific Git repository containing Terraform configurations.
   - The dir("terraform") command specifies that the git checkout will occur within a subdirectory called terraform.

2. *Stage: Plan*
   groovy
   stage('Plan') {
       steps {
           sh 'pwd;cd terraform/ ; terraform init'
           sh "pwd;cd terraform/ ; terraform plan -out tfplan"
           sh 'pwd;cd terraform/ ; terraform show -no-color tfplan > tfplan.txt'
       }
   }
   
   - This stage initializes the Terraform configuration and generates a plan for what changes will be made to the infrastructure.
   - terraform init: Initializes a Terraform working directory.
   - terraform plan -out tfplan: Creates an execution plan and writes it to a file named tfplan.
   - terraform show -no-color tfplan > tfplan.txt: Outputs the plan in a human-readable format to tfplan.txt.

3. *Stage: Approval*
   groovy
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
   
   - This stage prompts the user for manual approval to proceed with applying the changes.
   - The when block checks if autoApprove is not true. If the parameter is true, this stage will be skipped, and the pipeline will proceed directly to the Apply stage.
   - The input step shows the plan from tfplan.txt to the user and requests confirmation to proceed.

4. *Stage: Apply*
   groovy
   stage('Apply') {
       steps {
           sh "pwd;cd terraform/ ; terraform apply -input=false tfplan"
       }
   }
   
   - This final stage applies the changes defined in the plan (tfplan).
   - It runs the command to apply the Terraform changes to the infrastructure, using the output plan file and without asking for further input due to the -input=false option.

### Summary
Overall, this Jenkinsfile defines a standard Continuous Integration/Continuous Deployment (CI/CD) process for managing infrastructure with Terraform. It covers the following key operations: cloning a repository, initializing Terraform, generating a plan, optionally awaiting manual approval, and applying the changes. The use of parameterization allows for flexibility in how the pipeline is executed, particularly regarding automated approvals.
