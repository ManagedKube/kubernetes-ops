variable "vpc_id" {
  description = "The ID of the VPC in which to create the VPC endpoint"
}

variable "service_name" {
  description = "The service name for the VPC endpoint"
}

variable "vpc_endpoint_type" {
  description = "The type of VPC endpoint to create"
}
