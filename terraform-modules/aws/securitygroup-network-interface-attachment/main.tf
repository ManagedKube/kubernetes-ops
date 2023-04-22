data "aws_instances" "ec2list" {
  filter {
    name   = "tag:${var.fetch_ec2_instance_tag_name}"
    values = [var.fetch_ec2_instance_name]
  }
}

locals {
  primary_network_interface_ids = {
    for id in data.aws_instances.ec2list.ids :
    id => data.aws_instances.ec2list.instances[id].primary_network_interface_id
  }
}

resource "aws_network_interface_sg_attachment" "extra_sg_association" {
  for_each             = local.primary_network_interface_ids
  network_interface_id = each.value
  security_group_id    = var.fetch_ec2_instance_sg_id
}
