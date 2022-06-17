variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "cluster_name" {
  type        = string
  default     = "cluster"
  description = "EKS cluster name"
}

variable "eks_cluster_id" {
  type        = string
  default     = ""
  description = "EKS cluster ID"
}

variable "eks_cluster_oidc_issuer_url" {
  type        = string
  default     = ""
  description = "EKS cluster oidc issuer url"
}

variable "user_chart_name" {
  default = "external-dns"
  description = "The Helm name to install this chart under"
}

variable "helm_chart_version" {
  default = "1.9.0"
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

variable "route53_hosted_zones" {
  type = string
  default = "*"
  description = "The hosted zone permissions granted to: arn:aws:route53:::hostedzone/<route53_hosted_zones ID"
}
