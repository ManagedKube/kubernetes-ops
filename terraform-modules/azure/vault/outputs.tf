output "azurerm_key_vault_id" {
  value = azurerm_key_vault.this.id
}

output "azurerm_key_vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}
