variable "project_name" {
  description = "The GCP project name"
}

variable "region" {
  description = "The region to launch the vpc in."
}

variable "asn" {
  default = "-1"
  description = "ASN for the GCP router.  This value must not overlap with anyother ASNs"
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
  description = "The private subnet CIDR range. This should be a /24."
}

variable "public_subnet_cidr_range" {
  description = "The public subnet CIDR range. This should be a /24."
}

# variable "nat_machine_type" {
#   description = "The instance type for the NAT server."
# }
#
# variable "nat_image" {
#   description = "The prebuild NAT image."
# }
#
# variable "nat_internal_ip" {
#   description = "The IP address for the NAT server. This should usually be .253"
# }
#
# variable "internal_services_bastion_cidr" {
#   description = "The /32 address of the single bastion server that can access servers in the VPC over ssh."
# }

variable pods_ip_cidr_range {
  description = "The secondary ip range to use for pods"
}

variable services_ip_cidr_range {
  description = "The secondary ip range to use for services"
}

# # https://www.terraform.io/docs/providers/google/r/compute_route.html#tags
# variable "outbound_through_nat_tags" {
#   description = "A tag selector for nodes that should use the NAT as an external gateway"
#   type        = "list"
# }


#####################################
####################################
# variable "remote_state_bucket" {}
# variable "remote_state_bucket_region" {}
variable "cluster_name" {}

variable "oauth_scopes" {
  type = "list"
}

variable "labels" {
  type = "map"
  default = {}
}

variable "tags" {
  type = "list"
  default = []
}

variable "taints" {
  type = "list"
  default = []
}

variable "node_version" {
  default = "1.7.6"
}

variable master_ipv4_cidr_block {
  description = "Set the master ipv4 cidr block"
}

variable http_load_balancing {
  description = "Set this to false to ensure that the HTTP L7 load balancing controller addon is enabled"
  default     = false
}

variable "enable_private_kube_master_endpoint" {
  description = "Whether the master's internal IP address is used as the cluster endpoint"
  default = "true"
}

variable "enable_private_nodes" {
  description = "Sets the nodes to only private with no public IPs or not"
  default = "true"
}

variable master_authorized_networks_cidr {
  type = "list"
}

variable "machine_type" {}
variable "disk_size_gb" {}
variable "image_type" {}
variable "subnetwork" {}
variable "initial_node_count" {}
