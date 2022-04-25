resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
  apiVersion: karpenter.sh/v1alpha5
  kind: Provisioner
  metadata:
    name: ${data.aws_ssm_parameter.cluster_name.value}
  spec:
    requirements:
      - key: karpenter.sh/capacity-type
        operator: In
        values: ["spot"]
    limits:
      resources:
        cpu: 1000
        memory: 1000Gi
    provider:
      subnetSelector:
        karpenter.sh/discovery: ${data.aws_ssm_parameter.cluster_name.value}
      securityGroupSelector:
        "aws:eks:cluster-name": ${data.aws_ssm_parameter.cluster_name.value}
      tags:
        karpenter.sh/discovery: ${data.aws_ssm_parameter.cluster_name.value}
        Name: ${data.aws_ssm_parameter.cluster_name.value}-karpenter-node-group-instance
    ttlSecondsAfterEmpty: 30
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}
