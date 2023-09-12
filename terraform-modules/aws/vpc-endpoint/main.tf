module "endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = var.vpc_id
  security_group_ids = var.security_group_ids
  endpoints = var.endpoints
  subnet_ids = var.subnet_ids

  #security group
  create_security_group = var.create_security_group
  security_group_name_prefix = var.security_group_name_prefix
  security_group_description = var.security_group_description
  security_group_rules = var.security_group_rules
  security_group_tags = var.security_group_tags

  tags = var.tags
}