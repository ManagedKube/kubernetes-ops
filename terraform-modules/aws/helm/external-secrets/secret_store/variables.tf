variable "namespace" {
  type        = string
  default     = "external-secrets"
  description = "Namespace to install in"
}

variable "secret_store_name" {
  type        = string
  default     = "secretstore-main"
  description = "The secret stores name"
}

variable "environment_name" {
  type        = string
  default     = "env"
  description = "An environment name to attach to some resources.  Optional only needed if you are going to create more than one of these items in an AWS account"
}
