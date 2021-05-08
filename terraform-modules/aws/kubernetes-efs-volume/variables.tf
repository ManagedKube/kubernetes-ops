variable "efs_namespace" {
  type        = string
  default     = "kubernetes-ops"
  description = "Delimiter for EFS naming"
}

variable "environment_name" {
  type        = string
  default     = "env"
  description = "A name for this environment"
}

variable "efs_name" {
  type        = string
  default     = "efs"
  description = "A name for the EFS volume"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region this EFS will go into"
}

variable "vpc_id" {
  type        = string
  default     = "vcp-xxx"
  description = "VPC ID that this EFS will go into"
}

variable "subnets" {
  type        = list(string)
  default     = []
  description = "A list of subnets to place the EFS mount points at (can not have multiple subnets in the same availability zone"
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "A list of security groups to allow access to this EFS resource"
}
