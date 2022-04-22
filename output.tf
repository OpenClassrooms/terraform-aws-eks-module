output "eks_cluster_endpoint" {
  description = "The EKS cluster endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
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
