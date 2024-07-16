data "aws_iam_policy_document" "karpenter_assumerole_policy" {
  count = var.use_karpenter ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${trimprefix(aws_iam_openid_connect_provider.eks_openid_connect_provider.url, "https://")}:sub"
      values = [
        "system:serviceaccount:karpenter:karpenter",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${trimprefix(aws_iam_openid_connect_provider.eks_openid_connect_provider.url, "https://")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks_openid_connect_provider.arn]
    }
  }
}


resource "aws_iam_role" "karpenter_role_beta" {
  count              = var.use_karpenter ? 1 : 0
  name               = "${var.eks_cluster_name}-karpenter"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assumerole_policy[0].json


  inline_policy {
    name = "additional_karpenter_beta_grants_policy_${var.eks_cluster_name}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "AllowScopedEC2InstanceActions",
          Effect = "Allow",
          Resource = [
            "arn:*:ec2:${local.region}::image/*",
            "arn:*:ec2:${local.region}::snapshot/*",
            "arn:*:ec2:${local.region}:*:spot-instances-request/*",
            "arn:*:ec2:${local.region}:*:security-group/*",
            "arn:*:ec2:${local.region}:*:subnet/*",
            "arn:*:ec2:${local.region}:*:launch-template/*"
          ],
          Action = [
            "ec2:RunInstances",
            "ec2:CreateFleet"
          ]
        },
        {
          Sid    = "AllowScopedEC2InstanceActionsWithTags",
          Effect = "Allow",
          Resource = [
            "arn:*:ec2:${local.region}:*:fleet/*",
            "arn:*:ec2:${local.region}:*:instance/*",
            "arn:*:ec2:${local.region}:*:volume/*",
            "arn:*:ec2:${local.region}:*:network-interface/*",
            "arn:*:ec2:${local.region}:*:launch-template/*"
          ],
          Action = [
            "ec2:RunInstances",
            "ec2:CreateFleet",
            "ec2:CreateLaunchTemplate"
          ],
          Condition = {
            StringEquals = {
              "aws:RequestTag/kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
            },
            StringLike = {
              "aws:RequestTag/karpenter.sh/nodepool" = "*"
            }
          }
        },
        {
          Sid    = "AllowScopedResourceCreationTagging",
          Effect = "Allow",
          Resource = [
            "arn:*:ec2:${local.region}:*:fleet/*",
            "arn:*:ec2:${local.region}:*:instance/*",
            "arn:*:ec2:${local.region}:*:volume/*",
            "arn:*:ec2:${local.region}:*:network-interface/*",
            "arn:*:ec2:${local.region}:*:launch-template/*"
          ],
          Action = "ec2:CreateTags",
          Condition = {
            StringEquals = {
              "aws:RequestTag/kubernetes.io/cluster/${var.eks_cluster_name}" = "owned",
              "ec2:CreateAction" = [
                "RunInstances",
                "CreateFleet",
                "CreateLaunchTemplate"
              ]
            },
            StringLike = {
              "aws:RequestTag/karpenter.sh/nodepool" = "*"
            }
          }
        },
        {
          Sid      = "AllowScopedResourceTagging",
          Effect   = "Allow",
          Resource = "arn:*:ec2:${local.region}:*:instance/*",
          Action   = "ec2:CreateTags",
          Condition = {
            StringEquals = {
              "aws:ResourceTag/kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
            },
            StringLike = {
              "aws:ResourceTag/karpenter.sh/nodepool" = "*"
            },
            "ForAllValues:StringEquals" = {
              "aws:TagKeys" = [
                "karpenter.sh/nodeclaim",
                "Name"
              ]
            }
          }
        },
        {
          Sid    = "AllowScopedDeletion",
          Effect = "Allow",
          Resource = [
            "arn:*:ec2:${local.region}:*:instance/*",
            "arn:*:ec2:${local.region}:*:launch-template/*"
          ],
          Action = [
            "ec2:TerminateInstances",
            "ec2:DeleteLaunchTemplate"
          ],
          Condition = {
            StringEquals = {
              "aws:ResourceTag/kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
            },
            StringLike = {
              "aws:ResourceTag/karpenter.sh/nodepool" = "*"
            }
          }
        },
        {
          Sid      = "AllowRegionalReadActions",
          Effect   = "Allow",
          Resource = "*",
          Action = [
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeImages",
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceTypeOfferings",
            "ec2:DescribeInstanceTypes",
            "ec2:DescribeLaunchTemplates",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSpotPriceHistory",
            "ec2:DescribeSubnets"
          ],
          Condition = {
            StringEquals = {
              "aws:RequestedRegion" = "${local.region}"
            }
          }
        },
        {
          Sid      = "AllowSSMReadActions",
          Effect   = "Allow",
          Resource = "arn:*:ssm:${local.region}::parameter/aws/service/*",
          Action   = "ssm:GetParameter"
        },
        {
          Sid      = "AllowPricingReadActions",
          Effect   = "Allow",
          Resource = "*",
          Action   = "pricing:GetProducts"
        },
        {
          Sid      = "AllowInterruptionQueueActions",
          Effect   = "Allow",
          Resource = "arn:*:sqs:${local.region}:${local.account_id}:Karpenter-${var.eks_cluster_name}",
          Action = [
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes",
            "sqs:GetQueueUrl",
            "sqs:ReceiveMessage"
          ]
        },
        {
          Sid      = "AllowPassingInstanceRole",
          Effect   = "Allow",
          Resource = "arn:*:iam::${local.account_id}:role/${var.eks_cluster_name}-node-group-role",
          Action   = "iam:PassRole",
          Condition = {
            StringEquals = {
              "iam:PassedToService" = "ec2.amazonaws.com"
            }
          }
        },
        {
          Sid      = "AllowScopedInstanceProfileCreationActions",
          Effect   = "Allow",
          Resource = "*",
          Action   = "iam:CreateInstanceProfile",
          Condition = {
            StringEquals = {
              "aws:RequestTag/kubernetes.io/cluster/${var.eks_cluster_name}" = "owned",
              "aws:RequestTag/topology.kubernetes.io/region"                 = "${local.region}"
            },
            StringLike = {
              "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*"
            }
          }
        },
        {
          Sid      = "AllowScopedInstanceProfileTagActions",
          Effect   = "Allow",
          Resource = "*",
          Action   = "iam:TagInstanceProfile",
          Condition = {
            StringEquals = {
              "aws:ResourceTag/kubernetes.io/cluster/${var.eks_cluster_name}" = "owned",
              "aws:ResourceTag/topology.kubernetes.io/region"                 = "${local.region}",
              "aws:RequestTag/kubernetes.io/cluster/${var.eks_cluster_name}"  = "owned",
              "aws:RequestTag/topology.kubernetes.io/region"                  = "${local.region}"
            },
            StringLike = {
              "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*",
              "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"  = "*"
            }
          }
        },
        {
          Sid      = "AllowScopedInstanceProfileActions",
          Effect   = "Allow",
          Resource = "*",
          Action = [
            "iam:AddRoleToInstanceProfile",
            "iam:RemoveRoleFromInstanceProfile",
            "iam:DeleteInstanceProfile"
          ],
          Condition = {
            StringEquals = {
              "aws:ResourceTag/kubernetes.io/cluster/${var.eks_cluster_name}" = "owned",
              "aws:ResourceTag/topology.kubernetes.io/region"                 = "${local.region}"
            },
            StringLike = {
              "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
            }
          }
        },
        {
          Sid      = "AllowInstanceProfileReadActions",
          Effect   = "Allow",
          Resource = "*",
          Action   = "iam:GetInstanceProfile"
        },
        {
          Sid      = "AllowAPIServerEndpointDiscovery",
          Effect   = "Allow",
          Resource = "arn:*:eks:${local.region}:${local.account_id}:cluster/${var.eks_cluster_name}",
          Action   = "eks:DescribeCluster"
        }
      ]
    })
  }


}
