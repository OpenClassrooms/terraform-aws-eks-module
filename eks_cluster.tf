resource "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name

  version = var.eks_version

  role_arn                  = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids = concat(aws_subnet.public_subnet.*.id, aws_subnet.private_subnet.*.id)
  }

  timeouts {
    delete = "30m"
  }
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = false
  }

  tags = merge(var.tags, var.default_tags)
}

data "tls_certificate" "eks_cluster_tls_certificate" {
  url = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "eks_openid_connect_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_cluster_tls_certificate.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}
