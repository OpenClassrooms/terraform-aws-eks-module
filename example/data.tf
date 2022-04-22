data "aws_ssm_parameter" "eks_vpc_cidr" {
  name = "/vault/shared/aws/${var.ou_name}/eks/vpc_config/vpc_cidr"
}

data "aws_ssm_parameter" "eks_private_subnet_cidr" {
  name = "/vault/shared/aws/${var.ou_name}/eks/vpc_config/private_subnet_cidr"
}

data "aws_ssm_parameter" "eks_public_subnet_cidr" {
  name = "/vault/shared/aws/${var.ou_name}/eks/vpc_config/public_subnet_cidr"
}
