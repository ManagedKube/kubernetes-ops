variable "tags" {
  type = map(string)

  default = {
    Name        = "dev"
    Environment = "env"
    Account     = "dev"
    Group       = "devops"
    Location    = "East US 2"
    managed_by  = "Terraform"
  }
}

variable "kubernetes_cluster_id" {

}

variable "node_pool_name" {
  default = "generic"
}

variable "vm_size" {
  default = "Standard_B2s"
}

variable "enable_auto_scaling" {
  default = true
}

variable "node_count" {
  default = 1
}

variable "max_count" {
  default = 1
}

variable "min_count" {
  default = 1
}

variable "os_disk_size_gb" {
  default = "20"
}

variable "node_labels" {
  type    = map(string)
  default = {}
}

variable "node_taints" {
  type    = list(string)
  default = []
}
