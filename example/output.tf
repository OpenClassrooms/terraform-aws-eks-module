output "eks_cluster_endpoint" {
  description = "The EKS cluster endpoint"
  value       = module.my_example_module.eks_cluster_endpoint
}

output "eks_cluster_name" {
  description = "The EKS cluster name"
  value       = module.my_example_module.eks_cluster_name
}

output "cluster_ca_certificate" {
  description = "The EKS cluster CA Cert"
  value       = module.my_example_module.cluster_ca_certificate
}

output "vpc_eips" {
  description = "The EKS VPC EIPs"
  value       = module.my_example_module.vpc_eips
}
