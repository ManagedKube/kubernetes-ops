variable "project_name" {
  description = "The GCP project name"
}

variable "region" {
  description = "The region to launch the vpc in."
}

variable "credentials_file_path" {
  description = "A local path to a service account json credentials file."
}

variable "network_name" {
  description = "The name of this network"
}

variable "source_range_list" {
    type = list
    description = "The source range list of IPs"
}
