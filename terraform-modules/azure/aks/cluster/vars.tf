variable "location" {
    default = "eastus2"
}

variable "resource_group_name" {
    default = "kubernetes-ops-aks"
}

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

variable "cluster_name" {
    default = "dev"
}

variable "dns_prefix" {
    default = "dev"
}

variable "kubernetes_version" {
    default = "1.24.3"
}

variable "private_cluster_enabled" {
    default = false
}

variable "api_server_authorized_ip_ranges" {
    type = list(string)
    default = ["1.1.1.1/32"]
}

variable "enable_pod_security_policy" {
    default = false
}

variable "role_based_access_control_enabled" {
    default = true
}

variable "default_node_pool_name" {
    default = "default"
}

variable "default_node_pool_node_count" {
    default = 1
}

variable "default_node_pool_instance_size" {
    default = "Standard_B2s"
}

variable "default_node_pool_enable_auto_scaling" {
    default = true
}

variable "default_node_pool_max_count" {
    default = 1
}

variable "default_node_pool_min_count" {
    default = 1
}

variable "default_node_pool_os_disk_size_gb" {
    default = "30"
}

variable "default_node_pool_node_labels" {
    type = map(string)
    default = {}
}

variable "default_node_pool_node_taints" {
    type = list(string)
    default = []
}


variable "network_profile_network_plugin" {
    default = "kubenet"
}

variable "network_profile_network_policy" {
    default = "calico"
}

variable "network_profile_pod_cidr" {
    default = "10.244.0.0/16"
}

variable "kube_dashboard_enabled" {
    default = false
}

variable "default_node_pool_enable_host_encryption" {
    default = true
}

variable "auto_scaler_balance_similar_node_groups" {
  default = false
}

variable "auto_scaler_expander" {
  default = "least-waste"
}
