variable "name-postfix" {
  default = ""
}

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

variable "aws_first_access_key" {}

variable "aws_first_secret_key" {}

variable "aws_region" {}

variable "transit-gateway-arn" {
  description = "The transit gateways arn to attach to"
}

variable "transit-gateway-id" {
  description = "The transit gateways id to attach to"
}

variable "vpc_id_first" {
  description = "The VPC to create and attach the transit gateway to"
}

variable "subnets_cidr" {
  type = list(string)

  default = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
}

variable "availability_zone" {
  type = list(string)

  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
