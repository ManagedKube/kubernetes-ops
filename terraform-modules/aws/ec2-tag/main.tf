data "aws_instances" "existing_instances" {
  instance_state_names = ["running"]
}

data "aws_caller_identity" "current" {}

resource "aws_ec2_tag" "tag_existing_instances" {
  for_each    = toset(data.aws_instances.existing_instances.ids)
  resource_id = each.key

}

