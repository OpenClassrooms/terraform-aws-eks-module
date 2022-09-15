module "karpenter_irsa" {
  count   = var.use_karpenter ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "4.22.1"

  role_name                          = "karpenter-controller-${var.eks_cluster_name}"
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_id = aws_eks_cluster.eks_cluster.id
  karpenter_controller_node_iam_role_arns = [
    aws_iam_role.eks_node_group_role[0].arn
  ]

  oidc_providers = {
    ex = {
      provider_arn               = aws_iam_openid_connect_provider.eks_openid_connect_provider.arn
      namespace_service_accounts = ["karpenter:karpenter"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicyKarpenter" {
  count      = var.use_karpenter ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = "karpenter-controller-${var.eks_cluster_name}"
  depends_on = [
    module.karpenter_irsa
  ]
}

resource "aws_iam_policy" "additional_karpenter_grants_policy" {
  count       = var.use_karpenter ? 1 : 0
  name        = "additional_karpenter_grants_policy"
  description = "Additional right for Karpenter controller"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "pricing:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
  depends_on = [
    module.karpenter_irsa
  ]
}

resource "aws_iam_role_policy_attachment" "additional_karpenter_grants_policy_attachment" {
  count      = var.use_karpenter ? 1 : 0
  policy_arn = aws_iam_policy.additional_karpenter_grants_policy[0].arn
  role       = "karpenter-controller-${var.eks_cluster_name}"
  depends_on = [
    module.karpenter_irsa
  ]
}
