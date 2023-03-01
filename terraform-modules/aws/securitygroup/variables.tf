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
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "A list of ingress rules to apply to the security group"
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "A list of egress rules to apply to the security group"
}
