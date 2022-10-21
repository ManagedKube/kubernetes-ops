variable "source_security_group_id" {
  description = "The source security group id of the security group to add the rules to"
}

variable "source_security_group_name" {
  description = "The source security group name of the security group to add the rules to"
}

variable "security_group_rule_config" {
  description = "The security group rule configuration for one rule"
}

variable "allow_security_group_id" {
  description = "The allowed security group ID of the security group to allow to this source_security_group_id"
}

variable "allow_security_group_name" {
  description = "The allowed security group name of the security group to allow to this source_security_group_id"
}
