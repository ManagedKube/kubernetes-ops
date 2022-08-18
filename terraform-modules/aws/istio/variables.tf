variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags"
}

variable "verify" {
  type        = bool
  default     = false
  description = "Verify the helm download"
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
  default     = "1.14.3"
  description = "The version of istio to install"
}

variable "install_helm_chart_istio_base" {
  type        = number
  default     = 1
  description = "Install this helm chart or not"
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

variable "install_helm_chart_istio_discovery" {
  type        = number
  default     = 1
  description = "Install this helm chart or not"
}
variable "istio_discovery_chart_name" {
  type        = string
  default     = "istiod"
  description = "The chart name for the istio-discovery helm install"
}

variable "helm_values_istiod" {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}

variable "install_helm_chart_istio_ingress" {
  type        = number
  default     = 1
  description = "Install this helm chart or not"
}

variable "istio_ingress_chart_name" {
  type        = string
  default     = "istio-ingress"
  description = "The chart name for the istio-discovery helm install"
}

variable "helm_values_istio_ingress" {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}

variable "install_helm_chart_istio_egress" {
  type        = number
  default     = 1
  description = "Install this helm chart or not"
}

variable "istio_egress_chart_name" {
  type        = string
  default     = "istio-egress"
  description = "The chart name for the istio-discovery helm install"
}

variable "helm_values_istio_egress" {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}
