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

variable "k8s_service_account_namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace to place the service account into"
}

variable "k8s_service_account_name" {
  type        = string
  default     = "cluster-autoscaler-aws-cluster-autoscaler"
  description = "Service account name"
}
