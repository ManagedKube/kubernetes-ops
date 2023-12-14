variable "msk_arn" {
  description = "ARN of the existing MSK cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "subnets" {
  description = "List of IDs of existing subnets"
  type        = list(string)
}

variable "security_groups" {
  description = "List of IDs of existing security groups"
  type        = list(string)
}

// Add any additional variables needed for your MSK VPC Connection configurations
