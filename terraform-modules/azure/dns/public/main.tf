resource "azurerm_dns_zone" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  soa_record          = var.soa_record
  tags                = var.tags
}
