data "aws_instances" "existing_instances" {
  instance_state_names = ["running"]
}

data "aws_caller_identity" "current" {}

locals {
  tags = {
    for instance_id, instance_tags in data.aws_instances.existing_instances.ids : instance_id => {
      for variable in ["Env", "Platform", "Domain_2", "Domain_3"] : variable => var.account_tags[data.aws_caller_identity.current.account_id][variable]
      if var.account_tags[data.aws_caller_identity.current.account_id][variable] != null
    }
  }
}

resource "aws_instance_tag" "tag_existing_instances" {
  count       = length(data.aws_instances.existing_instances.ids)
  instance_id = data.aws_instances.existing_instances.ids[count.index]

  tags = local.tags[data.aws_instances.existing_instances.ids[count.index]]
}
