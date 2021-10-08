variable "helm_chart_version" {
  default     = "1.5.4"
  description = "The version of this helm chart to use"
}

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
  default     = "cert-manager"
  description = "The Helm name to install this chart under"
}

variable "k8s_namespace" {
  default = "cert-manager"
}

variable "helm_values_2" {
  type        = string
  default     = ""
  description = "Helm values that will overwrite the helm chart defaults and this modules default for further user customization"
}

variable "route53_hosted_zones" {
  type        = string
  default     = "*"
  description = "The hosted zone permissions granted to: arn:aws:route53:::hostedzone/<route53_hosted_zones ID"
}

variable "ingress_class" {
  type        = string
  default     = "nginx-external"
  description = "The ingress class that will be used for the http01 resolver to put the inbound check onto"
}

variable "enable_http01_cluster_issuer" {
  type        = number
  default     = 1
  description = "Enable an http01 cluster issuer"
}

variable "enable_dns01_cluster_issuer" {
  type        = number
  default     = 1
  description = "Enable an dns01 cluster issuer"
}

variable "lets_encrypt_server" {
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
  description = "The Lets Encrypt validation server to go to.  The default is the live one."
}

variable "lets_encrypt_email" {
  type        = string
  default     = ""
  description = "An email address for cert administration purposes"
}

variable "domain_name" {
  type        = string
  default     = "example.com"
  description = "The domain name for DNS01 to resolve for"
}