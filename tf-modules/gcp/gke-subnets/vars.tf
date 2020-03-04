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

variable "network_name" {
  description = "The name of this network"
}

variable "private_subnet_cidr_range" {
  description = "The private subnet CIDR range"
}

variable "public_subnet_cidr_range" {
  description = "The public subnet CIDR range"
}


variable "pods_ip_cidr_range" {
  description = "The secondary ip range to use for pods"
}

variable "services_ip_cidr_range" {
  description = "The secondary ip range to use for services"
}
