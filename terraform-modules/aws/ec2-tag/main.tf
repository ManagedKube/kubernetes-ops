data "aws_instances" "existing_instances" {
  instance_state_names = ["running"]
}

data "aws_caller_identity" "current" {}

resource "aws_ec2_tag" "tag_existing_instances" {
  for_each    = toset(data.aws_instances.existing_instances.ids)
  resource_id = each.key

  dynamic "tag" {
    for_each = [
      for tag_key, tag_value in var.account_tags[data.aws_caller_identity.current.account_id] : {
        key   = tag_key
        value = tag_value
      }
      if tag_key in ["Env", "Platform", "Domain_2", "Domain_3"]
    ]

    content {
      key   = tag.key
      value = tag.value
    }
  }
}
