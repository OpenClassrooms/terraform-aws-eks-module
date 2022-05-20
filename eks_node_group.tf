# Node group part
resource "aws_eks_node_group" "eks_node_group" {
  count           = var.use_fargate ? 0 : 1
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.eks_cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role[0].arn
  subnet_ids      = aws_subnet.private_subnet.*.id
  capacity_type   = var.eks_node_group_instance_capacity_type

  scaling_config {
    desired_size = var.eks_node_group_instance_desired
    max_size     = var.eks_node_group_instance_max
    min_size     = var.eks_node_group_instance_min
  }

  launch_template {
    name    = aws_launch_template.eks_node_group_launch_template.name
    version = aws_launch_template.eks_node_group_launch_template.latest_version
  }

  instance_types = ["${var.eks_node_group_instance_types}"]
  tags           = merge(var.tags, var.default_tags, local.node_group_resources_additional_tags)
}
