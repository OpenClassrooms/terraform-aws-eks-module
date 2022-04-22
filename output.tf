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
