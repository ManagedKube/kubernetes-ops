resource "aws_instance_association" "extra_sg_association" {
  count = length(var.instance_security_group_pairs)

  instance_id      = var.instance_security_group_pairs[count.index].instance_id
  security_group_id = var.instance_security_group_pairs[count.index].security_group_id
}
