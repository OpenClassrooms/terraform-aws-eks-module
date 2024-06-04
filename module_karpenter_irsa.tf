module "karpenter_irsa" {
  count   = var.use_karpenter ? 1 : 0
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.8.5"

  cluster_name = var.eks_cluster_name
  # There is a total limitation of char length (< 38)
  iam_role_use_name_prefix = false
  iam_role_name            = md5(var.eks_cluster_name)

  irsa_oidc_provider_arn          = aws_iam_openid_connect_provider.eks_openid_connect_provider.arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  # Since Karpenter is running on an EKS Managed Node group,
  # we can re-use the role that was created for the node group
  create_iam_role = false
  node_iam_role_arn    = aws_iam_role.eks_node_group_role[0].arn
}
