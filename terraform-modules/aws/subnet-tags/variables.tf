variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  type        = string
  default     = "none"
  description = "The cluster name for the Kubernetes tags on the subnets"
}

variable "environment_name" {}
