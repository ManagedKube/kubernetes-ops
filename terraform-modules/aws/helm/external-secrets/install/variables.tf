variable "helm_version" {
  type        = string
  default     = "0.4.4"
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
  description = "Namespace to install in"
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

variable "environment_name" {
  type        = string
  default     = "env"
  description = "An environment name to attach to some resources.  Optional only needed if you are going to create more than one of these items in an AWS account"
}

variable "eks_cluster_oidc_issuer_url" {
  type        = string
  default     = ""
  description = "EKS cluster oidc issuer url"
}

variable "secrets_prefix" {
  type        = string
  default     = ""
  description = "The prefix to your AWS Secrets.  This allows this module to craft a more tightly controlled set of IAM policies to only allow it to get certain secrets"
}

variable "account_id" {
  type        = string
  default     = null
  description = "The account_id of your AWS Account. This allows sure the use of the account number in the role to mitigate issue of aws_caller_id showing *** by obtaining the value of account_id "
}