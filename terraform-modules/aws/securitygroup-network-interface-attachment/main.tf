data "aws_instances" "ec2list" {
  filter {
    name   = "tag:${var.fetch_ec2_instance_tag_name}"
    values = [var.fetch_ec2_instance_name]
  }
}

locals {
  instance_details = {
    for instance_id in data.aws_instances.ec2list.ids:
    instance_id => {
      instance_id = instance_id
      network_interface_id = data.aws_instance.ec2_details[instance_id].network_interface_id
    }
  }
}

data "aws_instance" "ec2_details" {
  for_each = toset(data.aws_instances.ec2list.ids)
  instance_id = each.value
}

resource "aws_network_interface_sg_attachment" "extra_sg_association" {
  for_each             = local.instance_details
  network_interface_id = each.value.network_interface_id
  security_group_id    = var.fetch_ec2_instance_sg_id
}
