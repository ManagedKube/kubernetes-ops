// loop through the sg rules list
// pass the allow_group_name name
module "sg_rules_list_loop" {
  source = "./sg_rules_list_loop"

  count = length(var.security_group_rule_list)

  security_group_list = var.security_group_list

  source_security_group_id   = var.source_security_group_id
  source_security_group_name = var.source_security_group_name

  security_group_rule_config = var.security_group_rule_list[count.index]
}
  