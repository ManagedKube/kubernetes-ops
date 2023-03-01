variable "name" {
  type = string
  description = "The name of the security group"
}

variable "description" {
  type = string
  description = "The description of the security group"
}

variable "vpc_id" {
  type = string
  description = "The ID of the VPC in which to create the security group"
}

variable "ingress_rules" {
  description = "A list of ingress rules to apply to the security group"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  description = "A list of egress rules to apply to the security group"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
}

variable "tags" {
    type = map(any)
    description = "A list of tags"
}