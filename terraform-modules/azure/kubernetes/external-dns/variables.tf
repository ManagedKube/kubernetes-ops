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
