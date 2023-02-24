terraform {
   required_version = ">= 1.3.0"
}

data "local_file" "policy"{
   filename = var.core_network_policy_document
}

locals {
  transit_gateway_arns = toset(var.transit_gateway_arn)
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
  for_each = local.transit_gateway_arns
  global_network_id   = "${module.cloudwan.global_network.id}"
  transit_gateway_arn = each.key
}
