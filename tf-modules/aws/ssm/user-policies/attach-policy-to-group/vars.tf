variable "group_list" {
  description = "A list of AWS IAM groups"
  type        = list
  default     = []
}

variable "policy_arn" {
  description = "the policy arn to assign to the group_list"
  default     = ""
}
