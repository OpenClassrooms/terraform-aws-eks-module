
# Permissions for node group
resource "aws_iam_role" "eks_node_group_role" {
  count = !var.use_fargate ? 1 : 0
  name  = "${var.eks_cluster_name}-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = merge(var.tags, var.default_tags, local.node_group_resources_additional_tags)
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  count      = !var.use_fargate ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  count      = !var.use_fargate ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  count      = !var.use_fargate ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  count      = var.use_karpenter ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_group_role[0].name
}

resource "aws_iam_role_policy_attachment" "ElasticLoadBalancingFullAccess" {
  count      = var.use_karpenter ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = aws_iam_role.eks_node_group_role[0].name
}

resource "aws_iam_policy" "eks_node_group_custom_policy" {
  count       = !var.use_fargate ? 1 : 0
  name        = "eks_node_group_custom_policy"
  description = "Policy that allows access to other resources (used by ALB controller to interact with albs)"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
        {
            "Sid": "EksNodeGroupCustomPolicy",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAvailabilityZones"
            ],
            "Resource": [
                "*"
            ]
        }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "claire_api_iam_role_policy_attachment" {
  count      = !var.use_fargate ? 1 : 0
  role       = aws_iam_role.eks_node_group_role[0].name
  policy_arn = aws_iam_policy.eks_node_group_custom_policy[0].arn
}
