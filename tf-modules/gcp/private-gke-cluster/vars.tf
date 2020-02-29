variable "project_name" {
  description = "The GCP project name"
}

variable "region" {
  description = "The region to launch the vpc in."
}

variable "asn" {
  default     = "-1"
  description = "ASN for the GCP router.  This value must not overlap with another ASNs"
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
#####################################
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

variable "cluster_autoscaling_enabled" {
  description = "To enable cluster_autoscaling_enabled or not"
  default = false
}

variable "resource_limits_enable" {
  type = list(any)
  description = "This controls if the resource_limits block is enabled or not"
  # When cluster_autoscaling_enabled==false
  default = []
  # When cluster_autoscaling_enabled==true, to configure the resource limits
  # default = [{
  #   type = "cpu",
  #   max = 1,
  #   min = 1,
  # }, {
  #   type = "memory",
  #   max = 1,
  #   min = 1,
  # }]
}

variable "cluster_autoscaling_auto_provisioning_defaults_oauth_scopes" {
  type    = list(string)
  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append",
  ]
}

variable "cluster_autoscaling_auto_provisioning_defaults_service_account" {
  default = ""
}

variable "cluster_autoscaling_autoscaling_profile" {
  default = "OPTIMIZE_UTILIZATION"
}
