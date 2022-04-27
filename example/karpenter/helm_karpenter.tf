resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.9.0"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = data.aws_ssm_parameter.karpenter_irsa_iam_role_arn.value
  }

  set {
    name  = "clusterName"
    value = data.aws_ssm_parameter.cluster_id.value
  }

  set {
    name  = "clusterEndpoint"
    value = data.aws_ssm_parameter.endpoint.value
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = data.aws_ssm_parameter.karpenter_iam_instance_profile_name.value
  }
}
