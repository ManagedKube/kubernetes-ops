variable "name" {
  description = "Name of the resource share"
  type        = string
}

variable "allow_external_principals" {
  description = "Boolean indicating whether principals outside the AWS organization can be associated with the resource share"
  type        = bool
  default     = false
}

variable "principals" {
  description = "List of principals to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN."
  type        = list(string)
  default     = []
}

variable "resources" {
  description = "Schema list of resources to associate to the resource share"
  type = list(object({
    name         = string # used as for_each key; cannot be an attribute of a resource in the same tfstate
    resource_arn = string # ARN of the resource to associate with the share; *can* be an attribute of a resource in the same tfstate
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to assign to the resource share"
  type        = map(string)
  default     = {}
}
