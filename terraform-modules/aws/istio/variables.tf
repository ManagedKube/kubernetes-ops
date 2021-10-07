variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags"
}

variable "create_namespace" {
  type        = number
  default     = 1
  description = "To create a namespace or not"
}

variable "namespace_name" {
  type        = string
  default     = "istio-system"
  description = "The namespace name"
}

variable "namespace_labels" {
  type = map(any)
  default = {
    managed_by = "terraform"
  }
  description = "Labels for the namespace"
}

variable "namespace_annotations" {
  type = map(any)
  default = {
    name = "istio"
  }
  description = "Annotations for the namespace"
}

variable "istio_version" {
  type        = string
  default     = "1.11.0"
  description = "The version of istio to install"
}

variable "istio_base_chart_name" {
  type        = string
  default     = "istio-base"
  description = "The chart name for the istio-base helm install"
}

variable "helm_values_istio_base" {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}
