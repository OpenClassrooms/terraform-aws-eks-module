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

# Getting VPC config on SSM 
data "aws_ssm_parameter" "eks_vpc_cidr" {
  name = "/vault/shared/aws/${var.ou_name}/eks/vpc_config/vpc_cidr"
}

data "aws_ssm_parameter" "eks_private_subnet_cidr" {
  name = "/vault/shared/aws/${var.ou_name}/eks/vpc_config/private_subnet_cidr"
}

data "aws_ssm_parameter" "eks_public_subnet_cidr" {
  name = "/vault/shared/aws/${var.ou_name}/eks/vpc_config/public_subnet_cidr"
}
