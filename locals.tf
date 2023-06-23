locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  # Used to determine correct partition (i.e. - `aws`, `aws-gov`, `aws-cn`, etc.)
  partition = data.aws_partition.current.partition

  vpc_tag_owned_or_shared = var.use_karpenter ? "owned" : "shared"

  vpc_public_subnet_name_tag = var.use_karpenter ? "${var.eks_cluster_name}-public-subnet" : "${var.eks_cluster_name}-node-group-subnet"

  vpc_private_subnet_name_tag = var.use_karpenter ? "${var.eks_cluster_name}-private-subnet" : "${var.eks_cluster_name}-fargate-subnet"

  vpc_public_additional_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  vpc_private_additional_subnet_tags = var.use_karpenter ? {
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery"          = var.eks_cluster_name
    "kubernetes.io/role/internal-elb" = 1
    } : {
    "kubernetes.io/role/internal-elb" = 1
  }

  node_group_resources_additional_tags = var.use_karpenter ? {
    # Tag node group resources for Karpenter auto-discovery
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    "karpenter.sh/discovery" = var.eks_cluster_name
    } : {
  }

  userdata = templatefile(
    "${path.module}/node-user-data.sh.tmpl",
    {
      "auto_node_rotation_days" = var.auto_node_rotation_days
    }
  )

}
