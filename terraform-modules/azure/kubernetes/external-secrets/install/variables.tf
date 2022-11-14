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

variable "env" {
  type        = string
  default     = "env"
  description = "An environment name to attach to some resources.  Optional only needed if you are going to create more than one of these items in an AWS account"
}

variable "oidc_k8s_issuer_url" {
  type        = string
  default     = ""
  description = "The OIDC k8s issuer url.  If using the kubernetes-ops/azure creation it would be in the AKS output."
}

variable "azure_tenant_id" {
  type        = string
  default     = ""
  description = "The Azure tenant id. If using the kubernetes-ops/azure creation it would be in the AKS output."
}
