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

# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_PolicyKarpenter" {
#   count   = var.use_karpenter ? 1 : 0
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = "karpenter-controller-${var.eks_cluster_name}"
# }

# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnlyKarpenter" {
#   count   = var.use_karpenter ? 1 : 0
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = "karpenter-controller-${var.eks_cluster_name}"
# }

# resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCoreKarpenter" {
#   count   = var.use_karpenter ? 1 : 0
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   role       = "karpenter-controller-${var.eks_cluster_name}"
# }
