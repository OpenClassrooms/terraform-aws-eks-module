# Example config to show how deploy this module

module "my_example_module" {
  source = "../../" # in this example, this is a local module. For real use, source will be "OpenClassrooms/eks-module/aws"

  eks_cluster_name = var.eks_cluster_name

  eks_logs_retention_in_days = 30

  use_fargate   = false
  use_karpenter = true

  eks_vpc_cidr            = nonsensitive(data.aws_ssm_parameter.eks_vpc_cidr.value)
  eks_public_subnet_cidr  = split(",", nonsensitive(data.aws_ssm_parameter.eks_public_subnet_cidr.value))
  eks_private_subnet_cidr = split(",", nonsensitive(data.aws_ssm_parameter.eks_private_subnet_cidr.value))


  tags = var.default_tags
}


# Store credentials/infos in SSM (for use with k8s management repo (for installing ingresses, helm templates, pods....))
resource "aws_ssm_parameter" "endpoint" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/endpoint"
  type     = "String"
  value    = module.my_example_module.eks_cluster_endpoint
  tags     = var.default_tags
}

resource "aws_ssm_parameter" "cluster_id" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/cluster_id"
  type     = "String"
  value    = module.my_example_module.eks_cluster_id
  tags     = var.default_tags
}

resource "aws_ssm_parameter" "cluster_name" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/cluster_name"
  type     = "String"
  value    = module.my_example_module.eks_cluster_name
  tags     = var.default_tags
}

resource "aws_ssm_parameter" "cluster_ca_certificate" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/cluster_ca_certificate"
  type     = "SecureString"
  value    = module.my_example_module.cluster_ca_certificate
  tags     = var.default_tags
}

resource "aws_ssm_parameter" "karpenter_irsa_iam_role_arn" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/karpenter_irsa_iam_role_arn"
  type     = "String"
  value    = module.my_example_module.karpenter_irsa_iam_role_arn
  tags     = var.default_tags
}

resource "aws_ssm_parameter" "karpenter_iam_instance_profile_name" {
  provider = aws.root
  name     = "/vault/shared/aws/${var.ou_name}/eks/${var.eks_cluster_name}/karpenter_iam_instance_profile_name"
  type     = "String"
  value    = module.my_example_module.karpenter_iam_instance_profile_name
  tags     = var.default_tags
}
