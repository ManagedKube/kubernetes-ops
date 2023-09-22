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

variable "cluster-autoscaler_helm_version" {
  type        = string
  default     = "9.24.0"
  description = "cluster-autoscaler helm chart version.  https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler"
}
