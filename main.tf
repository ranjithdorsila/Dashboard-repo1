provider "aws" {
  region = "us-west-2"
}

# Create the EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = "arn:aws:iam::YOUR_ACCOUNT_ID:role/EKS-Cluster-Role"
  
  vpc_config {
    subnet_ids = ["subnet-XXXXXXXX", "subnet-XXXXXXXX"]
  }
}

# Create a node group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = "arn:aws:iam::YOUR_ACCOUNT_ID:role/EKS-Node-Group-Role"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  subnet_ids = ["subnet-XXXXXXXX", "subnet-XXXXXXXX"]
}

# Deploy Kubernetes resources
resource "kubernetes_deployment" "my_app" {
  metadata {
    name      = "my-app"
    namespace = "default"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          name  = "my-app"
          image = "YOUR_DOCKER_IMAGE" # e.g., your_dockerhub_username/your_app:latest

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "my_app" {
  metadata {
    name      = "my-app-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "my-app"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
