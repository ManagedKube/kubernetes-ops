data "azurerm_virtual_network" "peer_1" {
  name                = var.peer_1_virtual_network_name
  resource_group_name = var.peer_1_resource_group
}

resource "azurerm_virtual_network_peering" "peer_1" {
  name                      = var.peer_1_name
  resource_group_name       = var.peer_1_resource_group
  virtual_network_name      = var.peer_1_virtual_network_name
  remote_virtual_network_id = data.azurerm_virtual_network.peer_2.id
  allow_forwarded_traffic   = var.peer_1_allow_forwarded_traffic
}

data "azurerm_virtual_network" "peer_2" {
  name                = var.peer_2_virtual_network_name
  resource_group_name = var.peer_2_resource_group
}

resource "azurerm_virtual_network_peering" "peer_2" {
  name                      = var.peer_2_name
  resource_group_name       = var.peer_2_resource_group
  virtual_network_name      = var.peer_2_virtual_network_name
  remote_virtual_network_id = data.azurerm_virtual_network.peer_1.id
  allow_forwarded_traffic   = var.peer_2_allow_forwarded_traffic
}
