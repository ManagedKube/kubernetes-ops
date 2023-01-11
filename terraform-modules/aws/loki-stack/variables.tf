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

variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "Kubernetes namespace to deploy into"
}

# Chart: https://github.com/grafana/helm-charts/tree/main/charts/loki-distributed
variable "helm_chart_version" {
  type        = string
  default     = "0.67.2" #"2.8.9"
  description = "The version of the Loki helm chart to use"
}

# Chart: https://github.com/grafana/helm-charts/tree/main/charts/promtail
variable "helm_chart_version_promtail" {
  type        = string
  default     = "6.8.1"
  description = "The version of the Loki helm chart to use"
}

variable "helm_values_2_promtail" {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module and would overwrite the helm_values input"
}

variable "dyanmodb_table_prefix" {
  type        = string
  default     = "loki_index_"
  description = "The DynamoDB table prefix to use.  This prefix will be used for the Loki table index and also used for the IAM permissions to only allow Loki access to this set of DynamoDB tables."
}

variable "tags" {
  type        = any
  default     = {}
  description = "AWS Tags"
}
