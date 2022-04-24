resource "aws_eks_fargate_profile" "eks_fargate_profile" {
  count                  = var.use_fargate ? 1 : 0
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "fargate-profile-${var.eks_cluster_name}"
  pod_execution_role_arn = aws_iam_role.eks_fargate_role[0].arn
  subnet_ids             = aws_subnet.private_subnet.*.id

  selector {
    namespace = "${var.eks_cluster_name}-fargate-namespace"
  }

  timeouts {
    create = "30m"
    delete = "30m"
  }

  tags = merge(var.tags, var.default_tags)
}
