resource "aws_iam_role" "eks_admin_role" {
  name               = "eks-admin-role"
  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Action" : "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${local.account_id}:root"
      },
      "Effect" : "Allow"
    }
  ]
}
EOF
  tags               = var.default_tags
}

resource "aws_iam_policy" "eks_admin_role_policy" {
  name        = "eks_admin_role_policy_${var.eks_cluster_name}"
  description = "EKS Admin role policy for cluster ${var.eks_cluster_name}"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Action": [
            "eks:*",
            "iam:ListRoles"
        ],
        "Resource": "*",
        "Effect": "Allow"
      }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "eks_admin_role_policy_attachment" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = aws_iam_policy.eks_admin_role_policy.arn
}
# resource "aws_iam_group_policy_attachment" "eks_admin_group_policy_attachment" {
#   group      = "eks-administrators"
#   policy_arn = aws_iam_policy.eks_admin_role_policy.arn
# }
