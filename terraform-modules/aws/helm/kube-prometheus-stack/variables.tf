variable helm_version {
  type        = string
  default     = "14.5.0"
  description = "Helm chart version"
}

variable verify {
  type        = bool
  default     = false
  description = "Verify the helm download"
}

variable namespace {
  type        = string
  default     = "monitoring"
  description = "Namespace to install in"
}

variable chart_name {
  type        = string
  default     = "kube-prometheus-stack"
  description = "Name to set the helm deployment to"
}
