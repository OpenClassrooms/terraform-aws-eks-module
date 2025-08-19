variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
}

variable "eks_version" {
  description = "The version of K8s you want to run"
  default     = "1.25"
}

variable "default_tags" {
  type = map(string)
  default = {
    module             = "eks"
    module_github_repo = "https://github.com/OpenClassrooms/terraform-aws-eks-module"
  }
}

variable "tags" {
  description = "The tags to apply"
  type        = map(string)
  default     = {}
}

variable "eks_logs_retention_in_days" {
  description = "The log retention in days for EKS logs"
  default     = 30
}

variable "use_fargate" {
  description = "Do you want to use fargate or manage your node group yourself?"
  default     = false
}

variable "eks_node_group_instance_types" {
  description = "The type of instances for nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_group_instance_disk_size" {
  description = "The disk size for node instances"
  default     = 50
}

variable "eks_node_group_instance_capacity_type" {
  description = "Choose between ON_DEMAND and SPOT"
  default     = "ON_DEMAND"
}

variable "eks_node_group_instance_min" {
  description = "The min instances nb for nodes"
  default     = 2
}

variable "eks_node_group_instance_max" {
  description = "The max instances nb for nodes"
  default     = 3
}

variable "eks_node_group_instance_desired" {
  description = "The desired instances nb for nodes"
  default     = 2
}

variable "eks_node_group_instance_ami_type" {
  description = "The AMI type for nodes"
  default     = "AL2023_x86_64"
  type        = string
}

variable "eks_vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
  default     = "10.20.0.0/16"
}

variable "eks_public_subnet_cidr" {
  type        = list(string)
  description = "Public subnets' CIDR blocks."
  default = [
    "10.20.10.0/24",
    "10.20.12.0/24",
  ]
}

variable "eks_private_subnet_cidr" {
  type        = list(string)
  description = "Private subnets' CIDR blocks."
  default = [
    "10.20.20.0/24",
    "10.20.22.0/24",
  ]
}

variable "use_karpenter" {
  description = "Do you want to use karpenter (https://karpenter.sh/) or manage your node group yourself?"
  default     = false
}

variable "use_external_secrets" {
  description = "Do you want to install an IRSA for external secrets? (role created will be <cluster_name>-external-secrets and service account authorized to assume it will be <cluster_name>-external-secrets)"
  default     = false
}

variable "default_aws_eks_addons" {
  description = "List of addons to manage"
  type        = map(map(string))
  default = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }
}

variable "additional_aws_eks_addons" {
  description = "List of addons to manage"
  type        = map(map(string))
  default     = {}
}
