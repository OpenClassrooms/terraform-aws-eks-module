data "aws_iam_policy_document" "ext_secrets_assumerole_policy" {
  count = var.use_external_secrets ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${trimprefix(aws_iam_openid_connect_provider.eks_openid_connect_provider.url, "https://")}:sub"

      values = [
        "system:serviceaccount:external-secrets:${var.eks_cluster_name}-external-secrets"
      ]
    }

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks_openid_connect_provider.arn]
    }
  }
}

resource "aws_iam_role" "ext_secrets_role" {
  count              = var.use_external_secrets ? 1 : 0
  name               = "${var.eks_cluster_name}-external-secrets"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ext_secrets_assumerole_policy[0].json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/SecretsManagerRead"
  ]

  inline_policy {
    name = "SsmReadFrom${var.eks_cluster_name}-external-secrets"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ssm:Get*",
            "ssm:Describe*",
            "ssm:List*"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }


}
