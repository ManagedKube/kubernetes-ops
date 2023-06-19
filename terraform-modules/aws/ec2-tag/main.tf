data "aws_instances" "existing_instances" {
  instance_state_names = ["running"]
}

data "aws_caller_identity" "current" {}

resource "aws_ec2_tag" "tag_instances" {
  for_each = data.aws_instances.running_instances.instances

  resource_id = each.value.id

  tags = {
    for key, value in each.value.tags : key => value
  }
  propagate_at_launch = false
}
