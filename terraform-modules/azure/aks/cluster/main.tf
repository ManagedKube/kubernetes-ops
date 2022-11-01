terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.29.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  kubernetes_version  = var.kubernetes_version
  private_cluster_enabled = var.private_cluster_enabled
  dns_prefix          = var.dns_prefix
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  enable_pod_security_policy = var.enable_pod_security_policy

  role_based_access_control_enabled = var.role_based_access_control_enabled

  network_profile {
      network_plugin = var.network_profile_network_plugin
      network_policy = var.network_profile_network_policy
      pod_cidr       = var.network_profile_pod_cidr
  }

  default_node_pool {
    name       = var.default_node_pool_name
    enable_host_encryption = var.default_node_pool_enable_host_encryption
    node_count = var.default_node_pool_node_count
    vm_size    = var.default_node_pool_instance_size
    enable_auto_scaling = var.default_node_pool_enable_auto_scaling
    max_count = var.default_node_pool_max_count
    min_count = var.default_node_pool_min_count
    os_disk_size_gb = var.default_node_pool_os_disk_size_gb

    node_labels = var.default_node_pool_node_labels
    node_taints = var.default_node_pool_node_taints
  }

  identity {
    type = "SystemAssigned"
  }

  tags   = var.tags
}
