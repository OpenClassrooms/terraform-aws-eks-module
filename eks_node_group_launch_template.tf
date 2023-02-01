resource "aws_launch_template" "eks_node_group_launch_template" {
  image_id = "" # let empty to let EKS choose his optimized image
  #   image_id = data.aws_ami.last_eks.image_id
  name                   = "${var.eks_cluster_name}-node-group-launch-template"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.eks_node_group_instance_disk_size
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, var.default_tags, local.node_group_resources_additional_tags, {
      Name = "${var.eks_cluster_name}-node-group-instance"
    })
  }
}
