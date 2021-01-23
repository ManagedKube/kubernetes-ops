variable "user_list" {
  description = "A list of AWS IAM users"
  type        = list
  default     = []
}

variable "policy_arn" {
  description = "the policy arn to assign to the user_list"
  default     = ""
}
