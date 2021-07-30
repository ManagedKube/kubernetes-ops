variable "project_name" {
  description = "The GCP project name"
}

variable "region" {
  description = "The region to launch the vpc in."
}

variable "credentials_file_path" {
  description = "A local path to a service account json credentials file."
}

variable "vpc_name" {
  description = "The name of the VPC."
}

variable "private_subnet_cidr_range" {
  description = "The private subnet CIDR range. This should be a /24."
}

variable "public_subnet_cidr_range" {
  description = "The public subnet CIDR range. This should be a /24."
}

variable "number_of_nat_ip_address_to_use" {
  description = "The number of external IPs to use on the NAT Gateway"
}

# https://www.terraform.io/docs/providers/google/r/compute_route.html#tags
variable "outbound_through_nat_tags" {
  description = "A tag selector for nodes that should use the NAT as an external gateway"
  type        = list(string)
}
