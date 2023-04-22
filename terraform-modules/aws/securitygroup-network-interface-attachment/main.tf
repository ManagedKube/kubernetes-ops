data "aws_instances" "ec2list" {
  filter {
    name   = "tag:${var.fetch_ec2_instance_tag_name}"
    values = [var.fetch_ec2_instance_name]
  }
}

locals {
  network_interfaces = {
    for instance_id in data.aws_instances.ec2list.ids :
    id => data.aws_network_interface.primary[instance_id].id
  }
}


resource "aws_network_interface_sg_attachment" "extra_sg_association" {
  for_each = local.network_interfaces
  network_interface_id = each.value.id
  security_group_id    = var.fetch_ec2_instance_sg_id
}
