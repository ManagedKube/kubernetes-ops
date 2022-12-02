output "subnets" {
  value     = azurerm_virtual_network.this.subnet
}

output "dns_servers" {
  value     = azurerm_virtual_network.this.dns_servers
}

output "vnet_id" {
  value     = azurerm_virtual_network.this.id
}

output "vnet_name" {
  value     = azurerm_virtual_network.this.name
}

output "vnet_location" {
  value     = azurerm_virtual_network.this.location
}

output "vnet_resource_group_name" {
  value     = azurerm_virtual_network.this.resource_group_name
}

output "vnet_guid" {
  value     = azurerm_virtual_network.this.guid
}

output "security_group_id" {
  value     = azurerm_network_security_group.this.id
}
