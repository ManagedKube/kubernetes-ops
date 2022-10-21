// If the allow group name matches the allowed security group name then add it in
resource "aws_security_group_rule" "sg_rule_from_groups" {
  count = var.security_group_rule_config.allow_group_name == var.allow_security_group_name ? 1 : 0

  type                     = var.security_group_rule_config.sg_type
  from_port                = var.security_group_rule_config.from_port
  to_port                  = var.security_group_rule_config.to_port
  protocol                 = var.security_group_rule_config.protocol
  description              = var.security_group_rule_config.description
  security_group_id        = var.source_security_group_id
  source_security_group_id = var.allow_security_group_id
}
