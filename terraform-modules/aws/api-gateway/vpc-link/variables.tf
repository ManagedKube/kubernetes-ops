variable "subnet_id" {
  description = "ID of the subnet for the load balancer"
}

variable "vpc_link_name" {
  description = "Name of the API Gateway VPC link"
}

variable "vpc_link_description" {
  description = "Description of the API Gateway VPC link"
}

# Load balancer
variable "subnet_id" {
  description = "ID of the subnet for the load balancer"
}

variable "load_balancer_name" {
  description = "Name of the load balancer"
}

variable "internal_lb" {
  description = "Flag to indicate if the load balancer is internal (true/false)"
  type        = bool
}

variable "load_balancer_type" {
  description = "Type of load balancer"
}

variable "tags" {
  type    = map(any)
  default = {}
}