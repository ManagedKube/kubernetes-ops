variable "cluster_policy" {
  type        = string
  default     = ""
  description = "Json Policy to MSK Cluster Policy"
}

variable "cluster_arn" {
  type        = string
  default     = ""
  description = "ARN to apply to MSK Cluster Policy"
}
