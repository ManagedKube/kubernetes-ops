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

variable "eks_cluster_oidc_issuer_url" {
  type        = string
  default     = ""
  description = "EKS cluster oidc issuer url"
}

variable "helm_values_2" {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module and would overwrite the helm_values input"
}
