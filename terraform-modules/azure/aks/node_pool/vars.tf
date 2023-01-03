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

variable "vnet_subnet_id" {
  type = string
  default = null
}

variable "zones" {
  type        = list(string)
  default     = ["1", "2", "3"]
  description = "(Optional) Specifies a list of Availability Zones in which this Kubernetes Cluster Node Pool should be located. Changing this forces a new Kubernetes Cluster Node Pool to be created."
}
