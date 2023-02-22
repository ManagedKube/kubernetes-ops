terraform {
   required_version = ">= 1.3.0"
}

data "local_file" "policy"{
   filename = var.core_network_policy_document
}

module "cloudwan" {
  source = "aws-ia/cloudwan/aws"
  version = "v1.0.0"

  global_network = {
    create      = var.global_network_create
    description = var.global_network_description

  }
  core_network = {
    description     = var.core_network_description
    id              = var.existing_global_network_id
    policy_document = data.local_file.policy.content
  }


  tags = var.tags
}

resource "aws_networkmanager_transit_gateway_registration" "tgw-register" {
  count = length(var.transit_gateway_arn)
  global_network_id   = "${module.cloudwan.global_network.id}"
  transit_gateway_arn = element(var.transit_gateway_arn, count.index)
}
