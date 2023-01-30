resource "tls_private_key" "eks_ssh_key" {
  count     = var.use_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "eks_key_pair" {
  count      = var.use_ssh_key ? 1 : 0
  key_name   = "eks_key_pair"
  public_key = tls_private_key.eks_ssh_key[0].public_key_openssh
}
