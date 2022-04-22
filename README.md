# terraform-aws-eks-module
# AWS EKS Terraform module

Terraform module which provision a complete EKS cluster.

## Usage

### EKS

```hcl
module "my_example_module" {
  source = "../" # in this example, this is a local module. For real use, source will be "OpenClassrooms/eks-module/aws"

  eks_cluster_name = "eks-example"

  eks_logs_retention_in_days = 30

  eks_node_group_instance_types   = "c5.xlarge"
  eks_node_group_instance_min     = 2
  eks_node_group_instance_max     = 5
  eks_node_group_instance_desired = 2

  eks_vpc_cidr            = "10.20.0.0/16"
  eks_public_subnet_cidr  = [
    "10.20.10.0/24",
    "10.20.12.0/24",
  ]
  eks_private_subnet_cidr = [
    "10.120.10.0/24",
    "10.120.12.0/24",
  ]


  tags = var.default_tags
}

```

## Example

[Complete example](https://github.com/OpenClassrooms/terraform-aws-eks-module/blob/master/example/main.tf) - Create a complete cluster


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.2 |
