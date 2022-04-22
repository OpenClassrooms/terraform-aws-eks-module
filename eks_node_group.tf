# Node group part
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.eks_cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = aws_subnet.public_subnet.*.id

  scaling_config {
    desired_size = var.eks_node_group_instance_desired
    max_size     = var.eks_node_group_instance_max
    min_size     = var.eks_node_group_instance_min
  }

  instance_types = ["${var.eks_node_group_instance_types}"]
  tags           = merge(var.tags, var.default_tags)
}
