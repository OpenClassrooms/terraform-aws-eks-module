data "aws_eks_addon_version" "this" {
  for_each = { for k, v in merge(var.var.default_aws_eks_addons, var.var.additional_aws_eks_addons) : k => v }

  addon_name         = try(each.value.name, each.key)
  kubernetes_version = coalesce(var.eks_version, aws_eks_cluster.eks_cluster.version)
  most_recent        = try(each.value.most_recent, null)
}

resource "aws_eks_addon" "eks_addons_to_install" {
  for_each = merge(var.var.default_aws_eks_addons, var.var.additional_aws_eks_addons)

  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = each.key

  addon_version               = coalesce(try(each.value.addon_version, null), data.aws_eks_addon_version.this[each.key].version)
  preserve                    = try(each.value.preserve, true)
  resolve_conflicts_on_create = try(each.value.resolve_conflicts_on_create, "OVERWRITE")
  resolve_conflicts_on_update = try(each.value.resolve_conflicts_on_update, "OVERWRITE")
}



