pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'your_dockerhub_username/your_app:latest'
        AWS_REGION = 'us-west-2'  // Change as needed
        EKS_CLUSTER_NAME = 'my-cluster'
        TF_VAR_aws_access_key = credentials('aws-access-key-id') // Jenkins credential ID
        TF_VAR_aws_secret_key = credentials('aws-secret-access-key') // Jenkins credential ID
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the Git repository
                git 'https://github.com/your-repo.git' // Update with your repo URL
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t $DOCKER_IMAGE .'
                    // Push the Docker image to Docker Hub
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Change directory to where your Terraform files are located
                    dir('terraform') {  // Adjust if your Terraform files are in a different folder
                        // Initialize Terraform
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply Terraform configuration
                    dir('terraform') {  // Adjust if needed
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker images
            sh 'docker rmi $DOCKER_IMAGE || true'
        }

        success {
            echo 'Deployment successful!'
        }

        failure {
            echo 'Deployment failed.'
        }
    }
}
