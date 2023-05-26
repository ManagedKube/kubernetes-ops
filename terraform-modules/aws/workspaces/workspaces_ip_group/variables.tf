variable "account_name" {
  description = "The name of the AWS account"
  type        = string
}

variable "ip_group_rules" {
  description = <<EOT
    A list of IP group rules with source and description.
    Example:
    [
    {
        source      = "150.24.14.0/24"
        description = "NY"
    },
    {
        source      = "125.191.14.85/32"
        description = "LA"
    },
    {
        source      = "44.98.100.0/24"
        description = "STL"
    }
    ]
    EOT
  type  = list(object({
    source      = string
    description = string
  }))
  default = []
}

variable "tags" {
  description = "A map of key-value pairs to assign as tags to the AWS resources created by this Terraform configuration."
  type    = map(any)
  default = {}
}

