output "eks_cluster_endpoint" {
  description = "The EKS cluster endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_id" {
  description = "The EKS cluster id (not always the same as the cluster_name)"
  value       = aws_eks_cluster.eks_cluster.id
}

output "eks_cluster_name" {
  description = "The EKS cluster name"
  value       = var.eks_cluster_name
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = try(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "")
}

output "cluster_oidc_provider_thumbprint" {
  description = "The thumbprint of the OpenID Connect identity provider"
  value       = try(data.tls_certificate.eks_cluster_tls_certificate.certificates.0.sha1_fingerprint, "")
}

output "cluster_identity_oidc_issuer_arn" {
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
  value       = try(aws_iam_openid_connect_provider.eks_openid_connect_provider.arn, "")
}

output "cluster_ca_certificate" {
  description = "The EKS cluster CA Cert"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "vpc_id" {
  description = "The EKS VPC id"
  value       = aws_vpc.vpc.id
}

output "vpc_eips" {
  description = "The EKS VPC EIPs"
  value       = join(",", aws_eip.nat_gateway_eip.*.public_ip)
}

output "eks_admin_role_name" {
  description = "The EKS admin role name"
  value       = aws_iam_role.eks_admin_role.name
}

output "eks_node_group_role_name" {
  description = "The EKS node_group role name"
  value       = var.use_fargate ? "" : aws_iam_role.eks_node_group_role[0].name
}

output "karpenter_irsa_iam_role_arn_beta" {
  description = "The karpenter_irsa iam role arn Beta"
  value       = var.use_karpenter ? aws_iam_role.karpenter_role_beta[0].arn : null
}

output "karpenter_iam_instance_profile_name" {
  description = "The karpenter iam instance profile name"
  value       = var.use_karpenter ? aws_iam_instance_profile.karpenter[0].name : null
}

output "karpenter_queue_name" {
  description = "The karpenter SQS queue name"
  value       = var.use_karpenter ? module.karpenter_irsa[0].queue_name : null
}

output "cluster_security_group_id" {
  description = "The SG id generated and used by the cluster"
  value       = try(aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id, "")
}
