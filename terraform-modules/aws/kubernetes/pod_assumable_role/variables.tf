variable "name" {
  type        = string
  description = "The name to use for the various resources: IAM role, policy, etc"
}

variable "eks_cluster_oidc_issuer_url" {
  type        = string
  default     = ""
  description = "EKS cluster oidc issuer url"
}

variable "k8s_namespace" {
  type        = string
  description = "The namespace that this service account will be used in"
  default     = "my_namespace"
}

variable "iam_policy_description" {
  type        = string
  description = "The description to place onto the IAM policy"
  default     = "The policy created by the pod_assumable_role Terraform module"
}

variable "tags" {
  type        = map(any)
  description = "Set of tags to place on the resources"
  default     = {}
}

variable "iam_policy_json" {
  type        = string
  description = "The IAM policy json"
  default     = "{}"
}

variable "iam_policy_arns" {
  type        = list(string)
  description = "The IAM policy readonly list"
  default     = []
}
