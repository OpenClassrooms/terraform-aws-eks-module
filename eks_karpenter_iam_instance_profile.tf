resource "aws_iam_instance_profile" "karpenter" {
  count = var.use_karpenter ? 1 : 0
  name  = "KarpenterNodeInstanceProfile-${var.eks_cluster_name}"
  role  = aws_iam_role.eks_node_group_role[0].name
}
