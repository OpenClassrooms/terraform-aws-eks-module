# Permissions for fargate
resource "aws_iam_role" "eks_fargate_role" {
  count                 = var.use_fargate ? 1 : 0
  name                  = "${var.eks_cluster_name}-fargate_cluster_role"
  description           = "Allow fargate cluster to allocate resources for running pods"
  force_detach_policies = true
  assume_role_policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "eks.amazonaws.com",
          "eks-fargate-pods.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = merge(var.tags, var.default_tags)

}

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  count      = var.use_fargate ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  count      = var.use_fargate ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_fargate_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  count      = var.use_fargate ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_fargate_role[0].name
}
