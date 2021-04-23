variable helm_version {
  type        = string
  default     = "3.2.0"
  description = "Helm chart version"
}

variable verify {
  type        = bool
  default     = false
  description = "Verify the helm download"
}

variable namespace {
  type        = string
  default     = "argocd"
  description = "Namespace to install in"
}

variable chart_name {
  type        = string
  default     = "argocd"
  description = "Name to set the helm deployment to"
}

variable helm_values {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}
