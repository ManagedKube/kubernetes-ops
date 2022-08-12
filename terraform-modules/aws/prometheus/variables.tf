variable "workspace_alias" {
  default = "prometheus-test"
}

variable "tags" {
  type        = map(any)
  description = "AWS tags"
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

variable "namespace" {
  type        = string
  default     = "external-secrets"
  description = "Namespace to install in"
}

variable "account_id" {
  type        = string
  default     = null
  description = "The account_id of your AWS Account. This allows sure the use of the account number in the role to mitigate issue of aws_caller_id showing *** by obtaining the value of account_id "
}

variable "secrets_prefix" {
  type        = string
  default     = ""
  description = "The prefix to your AWS Secrets.  This allows this module to craft a more tightly controlled set of IAM policies to only allow it to get certain secrets"
}

