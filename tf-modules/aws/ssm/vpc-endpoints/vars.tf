variable "tags" {
  type = map(string)

  default = {
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

variable "aws_vpc_id" {
  description = "The VPC ID this endpoint is going into"
}


variable "name" {
  description = "The postfix to add to the name"
  default = ""
}

variable "ingress_cidr" {
  type = list
  description = "The ingress cidr block range"
  default = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
}

variable "vpc_endpoint_subnets" {
  type = list
  description = "The ID of one or more subnets in which to create a network interface for the endpoint"
  default = []
}
