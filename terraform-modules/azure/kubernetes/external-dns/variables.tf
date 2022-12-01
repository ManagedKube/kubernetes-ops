variable "user_chart_name" {
  default = "external-dns"
  description = "The Helm name to install this chart under"
}

variable "helm_chart_version" {
  default = "1.11.0"
  description = "The version of this helm chart to use"
}

variable "k8s_namespace" {
  default = "external-dns"
}

variable "helm_values_2" {
  type = string
  default = ""
  description = "Helm values that will overwrite the helm chart defaults and this modules default for further user customization"
}

variable "azure_dns_id" {
  type = string
  default = ""
  description = "The Azure DNS ID. Can be the zone ID output: /subscriptions/1a2b3c4d-8d7c-4ad2-9c2f-12345678/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/dnsZones/mydomain.example.com"
}

variable "azure_tenant_id" {
  type = string
  default = ""
  description = "The Azure tenant ID"
}

variable "environment_name" {
  type = string
  default = "dev"
  description = "An arbitrary environment name"
}

variable "oidc_k8s_issuer_url" {
  type        = string
  default     = ""
  description = "The OIDC k8s issuer url.  If using the kubernetes-ops/azure creation it would be in the AKS output."
}

variable "role_definition_name" {
  type        = string
  default     = "Private DNS Zone Contributor"
  description = "The pre-defined azure role to use"
}

# variable "azure_subscription_id" {
#   type        = string
#   default     = null
#   description = "The Azure subscription id"
# }

variable "azure_resource_group_name" {
  type        = string
  default     = null
  description = "The Azure resource group"
}
