module "karpenter_irsa" {
  count   = var.use_karpenter ? 1 : 0
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "18.31.0"

  cluster_name = var.eks_cluster_name

  irsa_oidc_provider_arn          = aws_iam_openid_connect_provider.eks_openid_connect_provider.arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  # Since Karpenter is running on an EKS Managed Node group,
  # we can re-use the role that was created for the node group
  create_iam_role = false
  iam_role_arn    = aws_iam_role.eks_node_group_role[0].arn
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
  name        = "additional_karpenter_grants_policy_${var.eks_cluster_name}"
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
