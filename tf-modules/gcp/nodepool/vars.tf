variable "project_name" {
  description = "The GCP project name"
}

variable "region" {
  description = "The region to launch the vpc in."
}

variable "credentials_file_path" {
  description = "A local path to a service account json credentials file."
}

variable "google_container_cluster_location" {
  description = "Location of the cluster to make it a regional or zonal cluster"
}

variable "cluster_name" {
  default = "dev"
}

variable "oauth_scopes" {
  type    = list(string)
  default = []
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "taints" {
  type    = list(map(string))
  default = []
  # default = {}
}

variable "guest_accelerator" {
  type    = list(map(string))
  default = [{
    type = "nvidia-tesla-p4",
    count = 0
  }]
}

variable "node_version" {
  default = "1.7.6"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "disk_size_gb" {
  default = "10"
}

variable "disk_type" {
  default = "pd-standard"
}

variable "image_type" {
  default = "COS"
}

variable "initial_node_count" {
  default = "1"
}

variable "node_pool_name" {
  default = "custom_nodepool"
}

variable "min_node_count" {
  default = "0"
}

variable "max_node_count" {
  default = "3"
}

variable "is_preemtible" {
  default = "false"
}

variable "auto_upgrade" {
  default = false
}

variable "auto_repair" {
  default = true
}

variable "shielded_instance_config_enable_secure_boot" {
  default = true
}

variable "shielded_instance_config_enable_integrity_monitoring" {
  default = true
}
