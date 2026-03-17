# ---------------- GLOBAL CONFIGURATION ----------------

variable "aws_region" {
  description = "AWS region where all resources will be created"  # Defines AWS region (e.g., us-east-1)
  type        = string                                            # Data type is string
  default     = "us-east-1"                                       # Default region if not provided
}

variable "project_name" {
  description = "Project name used for tagging and resource naming" # Used for naming and tagging AWS resources
  type        = string
  default     = "lms-devops"                                        # Default project name
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"  # Identifies environment type
  type        = string
  default     = "dev"                                          # Default environment
}

# ---------------- EKS CONFIGURATION ----------------

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster"  # Version of Kubernetes used in cluster
  type        = string
  default     = "1.29"                                    # Default Kubernetes version
}

variable "vpc_cidr" {
  description = "CIDR block for VPC (network range)"  # Defines IP range for VPC
  type        = string
  default     = "10.0.0.0/16"                         # Default private network range
}

variable "availability_zones_count" {
  description = "Number of Availability Zones to use for high availability"  # Controls HA setup
  type        = number                                                        # Numeric value
  default     = 2                                                             # Uses 2 AZs by default
}

# ---------------- NODE GROUP CONFIGURATION ----------------

variable "node_group_instance_types" {
  description = "EC2 instance types used for EKS worker nodes"  # Defines instance size for nodes
  type        = list(string)                                    # Accepts list of instance types
  default     = ["t3.medium"]                                   # Default instance type
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes"  # Initial number of nodes created
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes"  # Lower scaling limit
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes"  # Upper scaling limit
  type        = number
  default     = 4
}

variable "enable_cluster_autoscaler" {
  description = "Enable Kubernetes cluster autoscaler for dynamic scaling"  # Enables auto scaling
  type        = bool                                                        # Boolean true/false
  default     = false                                                       # Disabled by default
}

# ---------------- IAM / JENKINS CONFIG ----------------

variable "jenkins_worker_iam_role_arn" {
  description = "IAM Role ARN for Jenkins workers (used for IRSA or node role access)" # IAM role for Jenkins permissions
  type        = string
  default     = ""                                                                      # Empty means not configured
}

# ---------------- ROUTE53 / DOMAIN CONFIG ----------------

variable "create_route53_zone" {
  description = "Set true to create a new Route53 hosted zone, false to use existing"  # Controls zone creation
  type        = bool
  default     = false                                                                  # Uses existing zone by default
}

variable "domain_name" {
  description = "Primary domain name"        # Main domain used for application
  type        = string
  default     = "manojdevops897.shop"        # Your domain name
}

variable "route53_zone_id" {
  description = "Existing Route53 hosted zone ID (required if not creating new)"  # Needed if using existing zone
  type        = string
  default     = ""                                                                # Fill this manually if needed
}

variable "route53_record_name" {
  description = "Subdomain name (e.g., app → app.manojdevops897.shop)"  # Defines subdomain
  type        = string
  default     = "app"                                                   # Default subdomain
}

# ---------------- ALB / INGRESS CONFIG ----------------

variable "alb_dns_name" {
  description = "DNS name of AWS Application Load Balancer (from Kubernetes Ingress)"  # ALB endpoint
  type        = string
  default     = ""                                                                     # Fill after ingress creation
}

variable "alb_zone_id" {
  description = "Hosted zone ID of ALB (used for Route53 alias record)"  # Required for DNS mapping
  type        = string
  default     = ""                                                       # Fill after ALB creation
}
