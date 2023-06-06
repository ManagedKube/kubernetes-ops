resource "azurerm_dns_zone" "this" {
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
