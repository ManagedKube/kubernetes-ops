variable "aws_region" {
    default = "us-east-1"
}
variable "tags" {}
variable "vpc_id" {
    default = ""
}
variable "private_subnets" {
    type = list
    default = []
}
variable "public_subnets" {
    type = list
    default = []
}

variable "cluster_name" {
    default = "test-cluster"
}

variable "cluster_version" {
    default = "1.18"
}

variable enable_irsa {
  type        = bool
  default     = true
  description = "enable_irsa"
}

variable cluster_endpoint_public_access {
  type        = bool
  default     = true
  description = "Enable or disable Kube API public access"
}

variable cluster_endpoint_public_access_cidrs {
  type        = list
  default     = [
    "0.0.0.0/0"
  ]
  description = "Kube API public endpoint allow access cidrs"
}
