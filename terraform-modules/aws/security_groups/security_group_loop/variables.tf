variable "source_security_group_id" {
  description = "The source security group id of the security group to add the rules to"
}

variable "source_security_group_name" {
  description = "The source security group name of the security group to add the rules to"
}

variable "security_group_list" {
  description = "The security groups list that was created in the previous step"
}

variable "security_group_rule_list" {
  description = "Security group rules list to add to this security group"
}
