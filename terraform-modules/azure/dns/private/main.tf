resource "azurerm_private_dns_zone" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name

#   dynamic "soa_record" {
#     for_each = var.soa_record

#     content {
#         email         = soa_record.value["email"]
#         host_name     = soa_record.value["host_name"]
#         expire_time   = soa_record.value["expire_time"]
#         minimum_ttl   = soa_record.value["minimum_ttl"]
#         refresh_time  = soa_record.value["refresh_time"]
#         retry_time    = soa_record.value["retry_time"]
#         serial_number = soa_record.value["serial_number"]
#         ttl           = soa_record.value["minimttlum_ttl"]
#         tags          = var.tags
#     }
#   }

  tags                = var.tags
}

data "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  count                 = var.enable_azurerm_private_dns_zone_virtual_network_link ? 1 : 0
  name                  = var.name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = data.azurerm_virtual_network.this.id
}
