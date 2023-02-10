resource "azurerm_key_vault_access_policy" "this" {
  count = length(var.access_policy)
  key_vault_id = var.key_vault_id
  tenant_id    = var.access_policy[count.index].tenant_id
  object_id    = var.access_policy[count.index].object_id

  certificate_permissions = var.access_policy[count.index].certificate_permissions
  key_permissions         = var.access_policy[count.index].key_permissions
  secret_permissions      = var.access_policy[count.index].secret_permissions
  storage_permissions     = var.access_policy[count.index].storage_permissions
}
