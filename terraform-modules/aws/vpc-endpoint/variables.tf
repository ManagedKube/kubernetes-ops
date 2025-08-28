variable "vpc_id" {
  description = "ID of the VPC where the VPC endpoint will be created"
}

variable "security_group_id" {
  description = "ID of the security group to associate with the VPC endpoint"
}

variable "subnet_ids" {
  description = "List of subnet IDs where the VPC endpoint will be deployed"
  type        = list(string)
}

variable "service_name" {
  description = "Service name for the VPC endpoint"
}

variable "vpc_endpoint_type" {
  description = "Type of VPC endpoint"
  default     = "Interface"
}

variable "private_dns_enabled" {
  description = "Enable private DNS for the VPC endpoint"
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(any)
  default = {}
}