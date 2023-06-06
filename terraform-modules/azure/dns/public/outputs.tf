output "zone_id" {
  value = azurerm_dns_zone.this.id
}

output "nameservers" {
  value = azurerm_dns_zone.this.name_servers
}
