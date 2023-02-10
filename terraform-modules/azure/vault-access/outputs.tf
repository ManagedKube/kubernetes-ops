output "azurerm_key_vault_access_policy_id" {
  value = azurerm_key_vault_access_policy.this.*.id
}
