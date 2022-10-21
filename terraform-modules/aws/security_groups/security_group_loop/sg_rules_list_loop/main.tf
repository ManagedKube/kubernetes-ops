// loop through the security groups again to get the sg name/id and pass that down.
module "allow_sg_group_creation" {
  source = "./allow_sg_group_creation"

  count = length(var.security_group_list)

  source_security_group_id   = var.source_security_group_id
  source_security_group_name = var.source_security_group_name

  security_group_rule_config = var.security_group_rule_config

  allow_security_group_id   = var.security_group_list[count.index].id
  allow_security_group_name = var.security_group_list[count.index].name
}

// Add cidr block rules
resource "aws_security_group_rule" "sg_rule_from_cidr" {
  count = length(var.security_group_rule_config.cidr_blocks) > 0 ? 1 : 0

  type              = var.security_group_rule_config.sg_type
  from_port         = var.security_group_rule_config.from_port
  to_port           = var.security_group_rule_config.to_port
  protocol          = var.security_group_rule_config.protocol
  description       = var.security_group_rule_config.description
  security_group_id = var.source_security_group_id
  cidr_blocks       = var.security_group_rule_config.cidr_blocks
}

// Add external sg group
resource "aws_security_group_rule" "sg_rule_from_external_sg" {
  count = var.security_group_rule_config.group_type == "external_sg" ? 1 : 0

  type                     = var.security_group_rule_config.sg_type
  from_port                = var.security_group_rule_config.from_port
  to_port                  = var.security_group_rule_config.to_port
  protocol                 = var.security_group_rule_config.protocol
  description              = var.security_group_rule_config.description
  security_group_id        = var.source_security_group_id
  source_security_group_id = var.security_group_rule_config.allow_group_name
}
