data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_partition" "current" {}

# data "aws_ami" "last_eks" {
#   most_recent      = true
#   owners           = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amazon-eks-node-${var.eks_version}-v*"]
#   }
# }
