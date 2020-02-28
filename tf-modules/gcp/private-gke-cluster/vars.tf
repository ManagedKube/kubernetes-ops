variable "project_name" {
  description = "The GCP project name"
}

variable "region" {
  description = "The region to launch the vpc in."
}

variable "asn" {
  default     = "-1"
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

variable "private_subnet_name" {
  description = "The name of the private subnet to use"
}

#####################################
####################################
variable "cluster_name" {
}

variable "gke_version" {
  default = "1.7.6"
}

variable "master_ipv4_cidr_block" {
  description = "Set the master ipv4 cidr block"
}

variable "http_load_balancing" {
  description = "Set this to false to ensure that the HTTP L7 load balancing controller addon is enabled"
  default     = false
}

variable "enable_private_kube_master_endpoint" {
  description = "Whether the master's internal IP address is used as the cluster endpoint"
  default     = "true"
}

variable "enable_private_nodes" {
  description = "Sets the nodes to only private with no public IPs or not"
  default     = "true"
}

variable "master_authorized_networks_cidr" {
  type = list
}

variable "initial_node_count" {
}

variable "authenticator_groups_config" {
  default = "gke-security-groups@example.com"
}
