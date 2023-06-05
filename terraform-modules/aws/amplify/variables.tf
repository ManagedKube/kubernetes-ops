variable "name" {
  description = "The name of the Amplify App"
  type        = string
  default     = null
}

variable "repository_url" {
  description = "The URL of the Git repository for the Amplify App"
  type        = string
}

variable "enable_branch_auto_build" {
  description = "Enable branch auto-build for the Amplify App"
  type        = bool
  default     = false
}

variable "build_spec" {
  description = "Build spec for the Amplify App"
  type        = string
  default     = null
}

variable "custom_rules" {
  description = "Custom rules for the AWS Amplify App"
  type        = list(object({
    source    = string
    target    = string
    status    = string
  }))
  default = []
}

variable "environment_variables" {
  description = "Environment variables for the Amplify App"
  type        = map(string)
  default     = {}
}

variable "gh_access_token" {
  description = "GitHub access token for the Amplify App"
  type        = string
  sensitive   = true
}

variable "branch_name" {
  description = "The branch name to be deployed."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "The domain name to associate with the Amplify app."
  type        = string
  default     = null
}

variable "sub_domain_prefix" {
  description = "The subdomain prefix to associate with the branch."
  type        = string
  default     = null
}

variable "sub_domain_branch" {
  description = "The branch name to associate with the subdomain."
  type        = string
  default     = null
}

variable "tags" {
  type        = any
  default     = {}
  description = "A set of tags to place on the items"
}
