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

output "cluster_ca_certificate" {
  description = "The EKS cluster CA Cert"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "vpc_eips" {
  description = "The EKS VPC EIPs"
  value       = join(",", aws_eip.nat_gateway_eip.*.public_ip)
}

output "eks_admin_role_name" {
  description = "The EKS admin role name"
  value       = aws_iam_role.eks_admin_role.name
}

output "karpenter_irsa_iam_role_arn" {
  description = "The karpenter_irsa iam role arn"
  value       = var.use_karpenter ? module.karpenter_irsa[0].iam_role_arn : null
}

output "karpenter_iam_instance_profile_name" {
  description = "The karpenter iam instance profile name"
  value       = var.use_karpenter ? aws_iam_instance_profile.karpenter[0].name : null
}

