
variable "directory_service_directory_name" {
  type        = string
  description = "Name of Directory Service in Directory Name"
}

variable "directory_service_directory_name_password_secretsmanager_id" {
  type        = string
  default     = ""
  description = "The name of the AWS Secrets Manager secret that stores the password for the AWS Managed Microsoft AD directory."
}

variable "directory_service_directory_type" {
  type        = string
  default     = "SimpleAD"
  description = "The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values). Defaults to SimpleAD."
}

variable "directory_service_directory_edition" {
  type        = string
  default     = "Standard"
  description = "(Optional, for type MicrosoftAD only) The MicrosoftAD edition (Standard or Enterprise). Defaults to Enterprise."
}

variable "directory_service_directory_size" {
  type        = string
  default     = "Small"
  description = "(For SimpleAD and ADConnector types) The size of the directory (Small or Large are accepted values). Small by default."
}

variable "directory_service_enable_sso" {
  type        = bool
  default     = false
  description = "Whether to enable single-sign on for the directory. Requires alias. Defaults to false."
}

variable "directory_service_directory_vpc_id" {
  description = "VPC ID for the AWS Directory Service"
  type        = string
  default     = ""
}

variable "directory_service_directory_subnet_ids" {
  description = "List of subnet IDs to Directory Service"
  type        = list(string)
  default     = []
}

variable "workspaces_directory_subnet_ids" {
  description = "List of subnet IDs to workspaces directory"
  type        = list(string)
  default     = []
}

variable "workspaces_ip_group_ids" {
  description = "List of Ip Groups IDs to workspaces directory"
  type        = list(string)
  default     = []
}

variable "self_service_permissions_change_compute_type" {
  description = "Allow users to change compute type"
  type        = bool
  default     = true
}

variable "self_service_permissions_increase_volume_size" {
  description = "Allow users to increase volume size"
  type        = bool
  default     = true
}

variable "self_service_permissions_rebuild_workspace" {
  description = "Allow users to rebuild their workspace"
  type        = bool
  default     = true
}

variable "self_service_permissions_restart_workspace" {
  description = "Allow users to restart their workspace"
  type        = bool
  default     = true
}

variable "self_service_permissions_switch_running_mode" {
  description = "Allow users to switch running mode"
  type        = bool
  default     = true
}

variable "workspace_access_properties_device_type_android" {
  description = "Access property for Android devices"
  type        = string
  default     = "ALLOW"
}

variable "workspace_access_properties_device_type_chromeos" {
  description = "Access property for Chrome OS devices"
  type        = string
  default     = "ALLOW"
}

variable "workspace_access_properties_device_type_ios" {
  description = "Access property for iOS devices"
  type        = string
  default     = "ALLOW"
}

variable "workspace_access_properties_device_type_linux" {
  description = "Access property for Linux devices"
  type        = string
  default     = "DENY"
}

variable "workspace_access_properties_device_type_osx" {
  description = "Access property for macOS devices"
  type        = string
  default     = "ALLOW"
}

variable "workspace_access_properties_device_type_web" {
  description = "Access property for web devices"
  type        = string
  default     = "DENY"
}

variable "workspace_access_properties_device_type_windows" {
  description = "Access property for Windows devices"
  type        = string
  default     = "DENY"
}

variable "workspace_access_properties_device_type_zeroclient" {
  description = "Access property for Zero Client devices"
  type        = string
  default     = "DENY"
}

variable "workspace_creation_properties_custom_security_group_id" {
  description = "Custom security group ID for the WorkSpaces"
  type        = string
  default     = ""
}

variable "workspace_creation_properties_default_ou" {
  description = "Default organizational unit (OU) for WorkSpaces"
  type        = string
  default     = "OU=AWS,DC=Workgroup,DC=Example,DC=com"
}

variable "workspace_creation_properties_enable_internet_access" {
  description = "Enable internet access for WorkSpaces"
  type        = bool
  default     = true
}

variable "workspace_creation_properties_enable_maintenance_mode" {
  description = "Enable maintenance mode for WorkSpaces"
  type        = bool
  default     = true
}

variable "workspace_creation_properties_user_enabled_as_local_administrator" {
  description = "Enable WorkSpaces users as local administrators"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of key-value pairs to assign as tags to the AWS resources created by this Terraform configuration."
  type    = map(any)
  default = {}
}
