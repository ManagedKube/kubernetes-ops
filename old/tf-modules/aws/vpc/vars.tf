# Required

variable "tags" {
  type = map(string)

  default = {
    Name        = "dev"
    Environment = "env"
    Account     = "dev"
    Group       = "devops"
    Region      = "us-east-1"
    managed_by  = "Terraform"
  }
}

variable "region" {
  description = "AWS region (i.e. us-east-1)"
}

variable "vpc_cidr" {
  description = "VPC cidr block"
}

variable "availability_zones" {
  description = "AZs for subnets i.e. [us-east-1a, us-east-1b]"
  type        = list(string)
}

variable "public_cidrs" {
  description = "CIDR block for public subnets (should be the same amount as AZs)"
  type        = list(string)
}

variable "private_cidrs" {
  description = "CIDR block for private subnets (should be the same amount as AZs)"
  type        = list(string)
}

variable "optional_vpc_tags" {
  default = {}
  type    = map(string)
}

variable "security_group_default_egress" {
  default = ["0.0.0.0/0"]
}

