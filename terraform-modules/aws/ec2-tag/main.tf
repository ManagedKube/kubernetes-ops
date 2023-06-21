data "aws_instances" "existing_instances" {
  instance_state_names = ["running"]
}

data "aws_caller_identity" "current" {}

locals {
  instance_tags = flatten([
    for ec2_id in data.aws_instances.existing_instances.ids : [
      for key, value in var.account_tags[data.aws_caller_identity.current.account_id] : {
        resource_id = ec2_id
        key         = key
        value       = value
      }
    ]
  ])
}

resource "aws_ec2_tag" "tag_instances" {
  for_each = { for idx, tag in local.instance_tags : idx => tag }

  resource_id   = each.value.resource_id
  key           = each.value.key
  value         = each.value.value
}
