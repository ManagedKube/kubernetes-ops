#
# Role Vars
#
variable "trusted_role_arns" {
  description = "ARNs of AWS entities who can assume these roles"
  type        = list(string)
  default     = []
}

variable "create_role" {
  description = "Whether to create a role"
  type        = bool
  default     = false
}

variable "role_name" {
  description = "IAM role name"
  type        = string
  default     = ""
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "role_requires_mfa" {
  description = "Whether role requires MFA"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to IAM role resources"
  type        = map(string)
  default     = {}
}

variable "custom_role_policy_arns" {
  description = "List of ARNs of IAM policies to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "number_of_custom_role_policy_arns" {
  description = "Number of IAM policies to attach to IAM role"
  type        = number
  default     = null
}

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = ""
}

variable "role_sts_externalid" {
  description = "STS ExternalId condition values to use with a role (when MFA is not required)"
  type        = any
  default     = []
}
