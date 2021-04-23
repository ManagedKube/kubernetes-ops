variable helm_version {
  type        = string
  default     = "3.23.0"
  description = "Helm chart version"
}

variable verify {
  type        = bool
  default     = false
  description = "Verify the helm download"
}

variable namespace {
  type        = string
  default     = "nginx-ingress"
  description = "Namespace to install in"
}

variable chart_name {
  type        = string
  default     = "nginx-ingress"
  description = "Name to set the helm deployment to"
}
