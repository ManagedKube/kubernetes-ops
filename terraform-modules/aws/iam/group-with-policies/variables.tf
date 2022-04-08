variable "create_group" {
  description = "Whether to create IAM group"
  type        = bool
  default     = true
}

variable "group_name" {
  description = "Name of IAM group"
  type        = string
  default     = ""
}

variable "group_users" {
  description = "List of IAM users to have in an IAM group which can assume the role"
  type        = list(string)
  default     = []
}

variable "custom_group_policy_arns" {
  description = "List of IAM policies ARNs to attach to IAM group"
  type        = list(string)
  default     = []
}

variable "custom_group_policies" {
  description = "List of maps of inline IAM policies to attach to IAM group. Should have `name` and `policy` keys in each element."
  type        = list(map(string))
  default     = []
}

variable "attach_iam_self_management_policy" {
  description = "Whether to attach IAM policy which allows IAM users to manage their credentials and MFA"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}