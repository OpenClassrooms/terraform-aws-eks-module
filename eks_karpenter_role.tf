data "aws_iam_policy_document" "karpenter_assumerole_policy" {
  count = var.use_karpenter ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${trimprefix(aws_iam_openid_connect_provider.eks_openid_connect_provider.url, "https://")}:sub"
      values = [
        "system:serviceaccount:karpenter:karpenter",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${trimprefix(aws_iam_openid_connect_provider.eks_openid_connect_provider.url, "https://")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks_openid_connect_provider.arn]
    }
  }
}

resource "aws_iam_role" "karpenter_role" {
  count              = var.use_karpenter ? 1 : 0
  name               = "karpenter-${var.eks_cluster_name}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assumerole_policy[0].json

  inline_policy {
    name = "additional_karpenter_grants_policy_${var.eks_cluster_name}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "pricing:*",
            "ec2:*",
            "ssm:*",
            "sqs:*"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "iam:PassRole"
          ]
          Effect   = "Allow"
          Resource = "${aws_iam_role.eks_node_group_role[0].arn}"
        }
      ]
    })
  }


}
