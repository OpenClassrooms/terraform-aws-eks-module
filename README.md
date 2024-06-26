<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| tls | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| karpenter\_irsa | terraform-aws-modules/eks/aws//modules/karpenter | 18.31.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eip.nat_gateway_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_fargate_profile.eks_fargate_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_eks_node_group.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_instance_profile.karpenter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_openid_connect_provider.eks_openid_connect_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.AmazonEKSClusterCloudWatchMetricsPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks_admin_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks_node_group_custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_admin_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_cluster_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_fargate_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_node_group_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ext_secrets_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.karpenter_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSCloudWatchMetricsPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSFargatePodExecutionRolePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSVPCResourceController](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSVPCResourceController1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonSSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ElasticLoadBalancingFullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.claire_api_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_admin_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_template.eks_node_group_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_default_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_default_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ext_secrets_assumerole_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.karpenter_assumerole_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [tls_certificate.eks_cluster_tls_certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| default\_tags | n/a | `map(string)` | <pre>{<br>  "module": "eks",<br>  "module_github_repo": "https://github.com/OpenClassrooms/terraform-aws-eks-module"<br>}</pre> | no |
| eks\_cluster\_name | The name of the EKS cluster | `any` | n/a | yes |
| eks\_logs\_retention\_in\_days | The log retention in days for EKS logs | `number` | `30` | no |
| eks\_node\_group\_instance\_capacity\_type | Choose between ON\_DEMAND and SPOT | `string` | `"ON_DEMAND"` | no |
| eks\_node\_group\_instance\_desired | The desired instances nb for nodes | `number` | `2` | no |
| eks\_node\_group\_instance\_disk\_size | The disk size for node instances | `number` | `50` | no |
| eks\_node\_group\_instance\_max | The max instances nb for nodes | `number` | `3` | no |
| eks\_node\_group\_instance\_min | The min instances nb for nodes | `number` | `2` | no |
| eks\_node\_group\_instance\_types | The type of instances for nodes | `list(string)` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| eks\_private\_subnet\_cidr | Private subnets' CIDR blocks. | `list(string)` | <pre>[<br>  "10.20.20.0/24",<br>  "10.20.22.0/24"<br>]</pre> | no |
| eks\_public\_subnet\_cidr | Public subnets' CIDR blocks. | `list(string)` | <pre>[<br>  "10.20.10.0/24",<br>  "10.20.12.0/24"<br>]</pre> | no |
| eks\_version | The version of K8s you want to run | `string` | `"1.25"` | no |
| eks\_vpc\_cidr | VPC CIDR block. | `string` | `"10.20.0.0/16"` | no |
| tags | The tags to apply | `map(string)` | `{}` | no |
| use\_external\_secrets | Do you want to install an IRSA for external secrets? (role created will be <cluster\_name>-external-secrets and service account authorized to assume it will be <cluster\_name>-external-secrets) | `bool` | `false` | no |
| use\_fargate | Do you want to use fargate or manage your node group yourself? | `bool` | `false` | no |
| use\_karpenter | Do you want to use karpenter (https://karpenter.sh/) or manage your node group yourself? | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ca\_certificate | The EKS cluster CA Cert |
| cluster\_identity\_oidc\_issuer\_arn | The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account |
| cluster\_oidc\_issuer\_url | The URL on the EKS cluster for the OpenID Connect identity provider |
| cluster\_oidc\_provider\_thumbprint | The thumbprint of the OpenID Connect identity provider |
| cluster\_security\_group\_id | The SG id generated and used by the cluster |
| eks\_admin\_role\_name | The EKS admin role name |
| eks\_cluster\_endpoint | The EKS cluster endpoint |
| eks\_cluster\_id | The EKS cluster id (not always the same as the cluster\_name) |
| eks\_cluster\_name | The EKS cluster name |
| eks\_node\_group\_role\_name | The EKS node\_group role name |
| karpenter\_iam\_instance\_profile\_name | The karpenter iam instance profile name |
| karpenter\_irsa\_iam\_role\_arn | The karpenter\_irsa iam role arn |
| karpenter\_queue\_name | The karpenter SQS queue name |
| vpc\_eips | The EKS VPC EIPs |
| vpc\_id | The EKS VPC id |
<!-- END_TF_DOCS -->