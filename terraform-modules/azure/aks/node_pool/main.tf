# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = ">=3.29.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }

resource "azurerm_kubernetes_cluster_node_pool" "node_pool" {
  name                  = var.node_pool_name
  kubernetes_cluster_id = var.kubernetes_cluster_id
  vm_size               = var.vm_size
  node_count            = var.node_count
  enable_auto_scaling   = var.enable_auto_scaling
  max_count             = var.max_count
  min_count             = var.min_count

  vnet_subnet_id = var.vnet_subnet_id
  
  zones = var.zones

  node_labels = var.node_labels
  node_taints = var.node_taints

  tags = var.tags
}
