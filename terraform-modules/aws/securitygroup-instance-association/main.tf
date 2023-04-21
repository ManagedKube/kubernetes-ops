resource "aws_instance_association" "extra_sg_association" {
  count = !var.fetch_ec2_instances ? length(var.instance_security_group_pairs) : 0

  instance_id      = var.instance_security_group_pairs[count.index].instance_id
  security_group_id = var.instance_security_group_pairs[count.index].security_group_id
}

data "aws_instances" "example" {
  count = var.fetch_ec2_instances ? 1 : 0
  filter {
    name   = "tag:${var.fetch_ec2_instance_tag_name}"
    values = [var.fetch_ec2_instance_name] 
  }
}

data "null_data_source" "example" {
  count = var.fetch_ec2_instances ? 0 : 1
}

output "instance_ids" {
  value = var.fetch_ec2_instances ? tolist(data.aws_instances.example[0].ids) : []
}

resource "aws_instance_association" "extra_sg_association-fetch" {
  count = var.fetch_ec2_instances ? length(instance_ids) : 0

  instance_id      =  instance_ids[count.index].instance_id
  security_group_id = var.fetch_ec2_instance_sg_id
}
