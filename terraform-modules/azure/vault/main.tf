resource "azurerm_key_vault" "this" {
  name                = var.vault_name
  location            = var.azure_location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  public_network_access_enabled = var.public_network_access_enabled

  soft_delete_retention_days = var.soft_delete_retention_days

  purge_protection_enabled = var.purge_protection_enabled
}
