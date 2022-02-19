variable "cluster_name" {
  type = string
  description = "The name of the EKS cluster"
}

variable "kubernetes_api_host" {
  type = string
  description = "The eks kubernetes api host endpoint"
}

variable "cluster_ca_certificate" {
  type = string
  description = "The eks kubernetes cluster_ca_certificate"
}

variable "namespace" {
  type = string
  description = "The kubernetes namespace to deploy into"
  default = "istio-system"
}

variable "cert_common_name" {
  type = string
  description = "The common name for the certificate"
  default = ""
}

variable "cert_dns_name" {
  type = string
  description = "The dns name for the certificate"
  default = ""
}

variable "enable_certificate" {
  type = bool
  description = "If set to true, it will create the certificate resource on-demand"
  default = true
}

variable "issue_ref_name" {
  default = "letsencrypt-prod-dns01"
}

variable "issue_ref_kind" {
  default = "ClusterIssuer"
}

variable "issue_ref_group" {
  default = "cert-manager.io"
}

variable "gateway_hosts" {
  type    = list(string)
  description = "the list of hosts available for the gateway"
  default = ["*"]
}

variable "gateway_credentialName" {
  type    = string
  description = "This is the gateway matches the secretName field in the certificate"
  default = "domain-wildcard" 
}