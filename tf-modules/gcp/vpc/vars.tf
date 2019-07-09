variable "project_name" {
  description = "The GCP project name"
}

variable "region" {
  description = "The region to launch the vpc in."
}

variable "region_zone" {
  description = "The zone to launch the NAT in."
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

variable "nat_machine_type" {
  description = "The instance type for the NAT server."
}

variable "nat_image" {
  description = "The prebuild NAT image."
}

variable "nat_internal_ip" {
  description = "The IP address for the NAT server. This should usually be .253"
}

variable "internal_services_bastion_cidr" {
  description = "The /32 address of the single bastion server that can access servers in the VPC over ssh."
}
