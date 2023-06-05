variable "helm_version" {
  type        = string
  default     = "x.x.x"
  description = "Helm chart version"
}

variable "verify" {
  type        = bool
  default     = false
  description = "Verify the helm download"
}

variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "Namespace to install in"
}

variable "official_chart_name" {
  type        = string
  default     = "generic"
  description = "This is the official chart name that the source names it as.  This will be used for pulling the chart."
}


variable "user_chart_name" {
  type        = string
  default     = "my-chart-name"
  description = "This is the chart name that the user wants to deploy the chart as"
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Create the namespace if it doesnt exist"
}


variable "helm_values" {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}

variable "helm_values_2" {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module and would overwrite the helm_values input"
}

variable "repository" {
  type        = string
  default     = "https://example.com"
  description = "The URL to the helm chart"
}

variable "repository_key_file" {
  default = null
}

variable "repository_cert_file" {
  default = null
}

variable "repository_ca_file" {
  default = null
}

variable "repository_username" {
  default = null
}

variable "repository_password" {
  default = null
}

variable "devel" {
  default = null
}

variable "keyring" {
  default = null
}

variable "timeout" {
  default = 300
}

variable "disable_webhooks" {
  default = false
}

variable "reuse_values" {
  default = false
}

variable "force_update" {
  default = false
}

variable "recreate_pods" {
  default = false
}

variable "cleanup_on_fail" {
  default = false
}

variable "max_history" {
  default = 0
}

variable "atomic" {
  default = false
}

variable "skip_crds" {
  default = false
}

variable "render_subchart_notes" {
  default = true
}

variable "disable_openapi_validation" {
  default = false
}

variable "wait" {
  default = true
}

variable "wait_for_jobs" {
  default = false
}

variable "dependency_update" {
  default = false
}

variable "replace" {
  default = false
}

variable "pass_credentials" {
  default = false
}

variable "lint" {
  default = false
}
