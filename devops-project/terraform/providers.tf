terraform {
  required_version = ">= 1.0"          # Minimum Terraform version required

  required_providers {
    aws = {
      source  = "hashicorp/aws"       # AWS provider source
      version = "~> 5.0"              # Use AWS provider version 5.x
    }
    kubernetes = {
      source  = "hashicorp/kubernetes" # Kubernetes provider
      version = "~> 2.23"              # Version constraint
    }
    helm = {
      source  = "hashicorp/helm"      # Helm provider for deploying charts
      version = "~> 2.11"
    }
    tls = {
      source  = "hashicorp/tls"       # TLS provider for certs/keys
      version = "~> 4.0"
    }
  }

  # No backend configured → state stored locally (terraform.tfstate)
  # In real projects, use S3 backend with DynamoDB locking
}

provider "aws" {
  region = var.aws_region             # AWS region (e.g., us-east-1)

  default_tags {
    tags = {
      Project     = var.project_name  # Tag: project name
      Environment = var.environment   # Tag: environment (dev/prod)
      ManagedBy   = "Terraform"       # Tag: managed by Terraform
    }
  }
}

# Kubernetes provider (connects Terraform to EKS cluster)
provider "kubernetes" {
  host = module.eks.cluster_endpoint  # EKS API server endpoint

  # Decode base64 cluster certificate for secure communication
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  # Authentication using AWS CLI (IAM-based access)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"  # Auth API version
    command     = "aws"                                   # Use AWS CLI
    args = [
      "eks",                                              # AWS EKS service
      "get-token",                                        # Get authentication token
      "--cluster-name",
      module.eks.cluster_name                             # EKS cluster name
    ]
  }
}

# Helm provider (used to deploy apps into Kubernetes)
provider "helm" {
  kubernetes {
    host = module.eks.cluster_endpoint  # Same EKS endpoint

    # Cluster certificate for secure connection
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    # Authentication using AWS CLI
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name
      ]
    }
  }
}
