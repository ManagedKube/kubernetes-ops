variable "helm_version" {
  type        = string
  default     = "0.6.1"
  description = "Helm chart version"
}

variable "verify" {
  type        = bool
  default     = false
  description = "Verify the helm download"
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Create namespace if it does not exist"
}

variable "namespace" {
  type        = string
  default     = "external-secrets"
  description = "Namespace to install into"
}

variable "chart_name" {
  type        = string
  default     = "external-secrets"
  description = "Name to set the helm deployment to"
}

variable "helm_values" {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}
