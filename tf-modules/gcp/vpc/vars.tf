variable "project_name" {
  description = "The GCP project name"
}

variable "region" {
  description = "The region to launch the vpc in."
}

variable "bastion_region_zone" {
  description = "The zone to launch the bastion in."
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

variable "bastion_machine_type" {
  description = "The instance type for the bastion server."
}

variable "bastion_image" {
  description = "The prebuild bastion image."
}

variable "bastion_internal_ip" {
  description = "The IP address for the bastion server. This should usually be .253"
}

variable "internal_services_bastion_cidr" {
  description = "The /32 address of the single bastion server that can access servers in the VPC over ssh."
}

# # https://www.terraform.io/docs/providers/google/r/compute_route.html#tags
variable "outbound_through_nat_tags" {
  description = "A tag selector for nodes that should use the NAT as an external gateway"
  type        = list(string)
}

