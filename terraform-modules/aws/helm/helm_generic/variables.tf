variable helm_version {
  type        = string
  default     = "x.x.x"
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

variable official_chart_name {
  type        = string
  default     = "generic"
  description = "This is the official chart name that the source names it as.  This will be used for pulling the chart."
}


variable user_chart_name {
  type        = string
  default     = "my-chart-name"
  description = "This is the chart name that the user wants to deploy the chart as"
}

variable create_namespace {
  type        = bool
  default     = true
  description = "Create the namespace if it doesnt exist"
}


variable helm_values {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}

variable "helm_values_2" {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module and would overwrite the helm_values input"
}

variable repository {
  type        = string
  default     = "https://example.com"
  description = "The URL to the helm chart"
}

variable repository_username {
  type        = string
  default     = "username"
  description = "Username for private repo"
}

variable repository_password {
  type        = string
  default     = "password"
  description = "API Key for private repo"
}
