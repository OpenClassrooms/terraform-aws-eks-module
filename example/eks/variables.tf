variable "ou_name" {
  description = "The OU name"
  default     = "tools_internal"
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  default     = "eks-test"
}

variable "default_tags" {
  type = map(string)
  default = {
    additional_tag_1 = "tag_from_example"
  }
}
