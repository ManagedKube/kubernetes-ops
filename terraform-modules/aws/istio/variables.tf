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
  default     = "1.11.0"
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

variable "create_acm_cert" {
  type        = bool
  default     = false
  description = "Creates an ACM cert and applied to the istio ingress"
}

variable "acm_domain_name" {
  type        = string
  default     = "example.com"
  description = "The domain name to create a certificate for"
}

variable "acm_ttl" {
  type        = string
  default     = "300"
  description = "The certifcate TTL"
}

variable "acm_subject_alternative_names" {
  type        = list(string)
  default     = ["*.example.com"]
  description = "Subject alternative names for the cert (SAN)"
}

variable "acm_route53_zone_id" {
  type        = string
  default     = ""
  description = "The route53 zone ID to perform DNS validation on the ACM cert"
}
