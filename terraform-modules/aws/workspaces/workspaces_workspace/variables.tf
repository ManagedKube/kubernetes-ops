variable "bundle_id" {
  description = "The bundle ID for the AWS WorkSpaces"
  type        = string
  default     = "wsb-bh8rsxt14" # Value of Windows 10 (English)
}

variable "workspaces_directory_id" {
  description = "Directory ID where aws workspaces will store its users"
  type        = string
}


variable "root_volume_encryption_enabled" {
  description = "A boolean value indicating whether the root volume encryption is enabled."
  type        = bool
  default     = true
}

variable "user_volume_encryption_enabled" {
  description = "A boolean value indicating whether the user volume encryption is enabled."
  type        = bool
  default     = true
}

variable "volume_encryption_key" {
  description = "The key used for volume encryption."
  type        = string
  default     = "alias/aws/workspaces"
}

variable "workspaces" {
  description = <<-EOT
    A list of objects containing the configuration for each AWS Workspace to be created. Example:

      workspaces = [
        {
          user_name                                  = "john.doe"
          compute_type_name                          = "VALUE"
          user_volume_size_gib                       = 10
          root_volume_size_gib                       = 80
          running_mode                               = "AUTO_STOP"
          running_mode_auto_stop_timeout_in_minutes  = 60
        },
        {
          user_name                                  = "jane.doe"
          compute_type_name                          = "VALUE"
          user_volume_size_gib                       = 10
          root_volume_size_gib                       = 80
          running_mode                               = "AUTO_STOP"
          running_mode_auto_stop_timeout_in_minutes  = 60
        }
        # Add more workspace configurations as needed
      ]
  EOT
  type = list(object({
    user_name                                  = string
    compute_type_name                          = string
    user_volume_size_gib                       = number
    root_volume_size_gib                       = number
    running_mode                               = string
    running_mode_auto_stop_timeout_in_minutes  = number
  }))
}

variable "tags" {
  description = "A map of key-value pairs to assign as tags to the AWS resources created by this Terraform configuration."
  type    = map(any)
  default = {}
}
