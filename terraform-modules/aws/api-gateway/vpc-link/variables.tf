variable "vpc_link_name" {
  description = "Name of the API Gateway VPC link"
}

variable "vpc_link_description" {
  description = "Description of the API Gateway VPC link"
  default = ""
}

variable "vpc_link_nbl_arn" {
  description = "ARN of the NLB VPC link"
}

variable "tags" {
  type    = map(any)
  default = {}
}