variable "groups" {
  description = "A list of Azure Active Directory groups to create"
  type        = any
  default     = [
    {
      display_name     = "my-group"
      owners           = ["user object ID as the owner of the group"]
      security_enabled = true
      members          = ["user object ID as members"]
    },
  ]
}
