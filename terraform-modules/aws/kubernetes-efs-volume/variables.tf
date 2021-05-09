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

variable "kubernetes_namespace" {
  type        = string
  default     = "kubernetes-ops"
  description = "The namespaces the pvc should be deployed into"
}


variable "tags" {
  type    = map(any)
  default = {}
}

variable "reclaim_policy" {
  type        = string
  default     = "Retain"
  description = "Storage class reclaim policy"
}

variable "storage_class_parameters_provisioningMode" {
  type        = string
  default     = "efs-ap"
  description = "description"
}

variable "storage_class_parameters_directoryPerms" {
  type        = string
  default     = "700"
  description = "description"
}

variable "storage_class_parameters_gidRangeStart" {
  type        = string
  default     = "1000"
  description = "description"
}

variable "storage_class_parameters_gidRangeEnd" {
  type        = string
  default     = "2000"
  description = "description"
}

variable "storage_class_parameters_basePath" {
  type        = string
  default     = "/"
  description = "description"
}

variable "persistent_volume_reclaim_policy" {
  type        = string
  default     = "Retain"
  description = "persistent_volume_reclaim_policy"
}

variable "storage_capacity" {
  type        = string
  default     = "2Gi"
  description = "Size of the nfs disk"
}

variable "access_modes" {
  type        = list(any)
  default     = ["ReadWriteMany"]
  description = "access_modes"
}
