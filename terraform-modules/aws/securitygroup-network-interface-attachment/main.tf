data "aws_instances" "ec2" {
  filter {
    name   = "tag:${var.fetch_ec2_instance_tag_name}"
    values = [var.fetch_ec2_instance_name] 
  }
}

output "instance_ids" {
  value = tolist(data.aws_instances.ec2[0].ids)
}

resource "aws_network_interface_sg_attachment" "extra_sg_association" {
  count                     = length(instance_ids)
  network_interface_id      = instance_ids[count.index].primary_network_interface_id
  security_group_id         = var.fetch_ec2_instance_sg_id
}
