# terraform-aws-eks-module
# AWS EKS Terraform module

Terraform module which provision a complete EKS cluster.

## Prerequisites
- aws-iam-authenticator: install documentation available here: https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

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


## After terraform apply?

Ok, your terraform config is correctly applied. What next? You need to access the cluster and launch kubectl commands.

However, you need to do more setup before doing this.

/!\ After setup, ONLY the IAM user that created the cluster can access it. You have to patch aws-auth k8s configmap to allow other people to connects the cluster. We are assuming that only people you allow to assume role `eks-admin-role` will connect the cluster. This is a preconfigured role on this repo, but you can adapt it for your needs.

There is a [Makefile](https://github.com/OpenClassrooms/terraform-aws-eks-module/blob/master/example/Makefile) that allow to do these actions.

```
➜ jeremy.govi@FVFF31BRQ05P  ~/workspace/github.com/OpenClassrooms/terraform-aws-eks-module/example git:(master) make

Usage:
  make <target>

Targets from Makefile:
  => help: [HELP] show help
  => terraform_apply: Apply terraform config
  => generate_initial_kube_config: Generate First time setup Kubeconfig to access the cluster in order to setup IAM Accesses
  => backup_eks_awsauth_configmap: Connects to the EKS cluster with the root config to get the aws-auth configmap and save it
  => generate_kube_config: Generate Kubeconfig to access the cluster
  => display_eks_awsauth_configmap: Connects to the EKS cluster with the root config and display the aws-auth configmap
  => patch_eks_awsauth_configmap: Connects to the EKS cluster with the root config to patch the configmaps to allow other users to connect
```


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.2 |
