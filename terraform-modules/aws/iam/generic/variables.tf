variable iam_name {
  type        = string
  description = "Friendly name of the role"
}

variable iam_description {
  type        = string
  default     = "New Role created from ManagedKube Module"
  description = "(Optional) Description of the role."
}

variable iam_force_detach_policies {
  type        = bool
  default     = false
  description = "(Optional) Whether to force detaching any policies the role has before destroying it"
}

variable iam_max_session_duration {
  type        = number
  default     = 3600
  description = "(Optional) Maximum session duration (in seconds) that you want to set for the specified role his setting can have a value from 1 hour to 12 hours."
}



#Permission section-----------------------------------------
variable iam_inline_policy {
  type        = string
  description = "Json to create policy in line"
  default     = "{}"
}

variable iam_managed_policy_arns {
  type        = list(string)
  description = "List of arn policies to attached"
  default     = []
}
#End of Permission section----------------------------------


#Trust relationship section---------------------------------
variable iam_assume_role_policy {
  type        = string
  description = "Json to create assume_role_policy in line"
  default     = "{}"
}
#End Trust relationship section-----------------------------

variable "create_iam_instance_profile" {
  description = "Whether to create the IAM instance profile"
  type        = bool
  default     = false
}


variable tags {
  type = map(any)
  description = "Key-value mapping of tags for the IAM role. If configured with a provider"
}