locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  # Used to determine correct partition (i.e. - `aws`, `aws-gov`, `aws-cn`, etc.)
  partition = data.aws_partition.current.partition

  vpc_tag_owned_or_shared = var.use_karpenter ? "ownet" : "shared"

  vpc_public_subnet_name_tag = var.use_karpenter ? "${var.eks_cluster_name}-node-group-subnet" : "${var.eks_cluster_name}-public-subnet"

  vpc_private_subnet_name_tag = var.use_karpenter ? "${var.eks_cluster_name}-fargate-subnet" : "${var.eks_cluster_name}-private-subnet"

  vpc_public_additional_subnet_tags = var.use_karpenter ? {
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = var.eks_cluster_name
    } : {
    "kubernetes.io/role/elb" = 1
    "state"                  = "public"
  }

  vpc_private_additional_subnet_tags = var.use_karpenter ? {
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = var.eks_cluster_name
    } : {
    "kubernetes.io/role/internal-elb" = 1
    "state"                           = "private"
  }

}
