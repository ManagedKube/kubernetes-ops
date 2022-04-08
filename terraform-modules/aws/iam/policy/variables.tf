
variable "create_policy" {
  description = "Whether to create the IAM policy"
  type        = bool
  default     = true
}

variable "policy_name" {
  description = "The name of the policy"
  type        = string
  default     = ""
}

variable "policy_path" {
  description = "The path of the policy in IAM"
  type        = string
  default     = "/"
}

variable "policy_description" {
  description = "The description of the policy"
  type        = string
  default     = "IAM Policy"
}

variable "policy" {
  description = "The path of the policy in IAM (tpl file)"
  type        = string
  default     = ""
}

variable "policy_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

