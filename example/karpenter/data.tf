# AWS Credentials Root OU
data "aws_ssm_parameter" "aws_access_key_id_root" {
  name = "/vault/root/aws/iam/terraform/aws_access_key_id"
}

data "aws_ssm_parameter" "aws_secret_access_key_root" {
  name = "/vault/root/aws/iam/terraform/aws_secret_access_key"
}

data "aws_ssm_parameter" "aws_default_region_root" {
  name = "/vault/root/aws/iam/terraform/aws_default_region"
}

# Getting EKS configuration on Root SSM
data "aws_ssm_parameter" "endpoint" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/endpoint"
}

data "aws_ssm_parameter" "cluster_id" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/cluster_id"
}

data "aws_ssm_parameter" "cluster_name" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/cluster_name"
}

data "aws_ssm_parameter" "cluster_ca_certificate" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/cluster_ca_certificate"
}

data "aws_ssm_parameter" "karpenter_iam_instance_profile_name" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/karpenter_iam_instance_profile_name"
}

data "aws_ssm_parameter" "karpenter_irsa_iam_role_arn" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/karpenter_irsa_iam_role_arn"
}
