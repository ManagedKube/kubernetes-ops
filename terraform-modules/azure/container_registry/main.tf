data "azurerm_resource_group" "this" {
  name = var.azurerm_resource_group
}

resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.azurerm_resource_group
  location            = data.azurerm_resource_group.this.location
  sku                 = var.sku

#   identity {
#     type = "SystemAssigned"
#   }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.this.id
    ]
  }

  encryption {
    enabled            = true
    key_vault_key_id   = data.azurerm_key_vault_key.this.id
    identity_client_id = azurerm_user_assigned_identity.this.client_id
  }

  tags = var.tags

  depends_on = [
    azurerm_key_vault_access_policy.this
  ]
}

resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.this.principal_id

  key_permissions = [
    "Get", "WrapKey", "UnwrapKey"
  ]
}

resource "azurerm_user_assigned_identity" "this" {
  resource_group_name = var.azurerm_resource_group
  location            = data.azurerm_resource_group.this.location

  name = var.name
}

data "azurerm_key_vault_key" "this" {
  name         = azurerm_key_vault_key.generated.name
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_key" "generated" {
  name         = var.name
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}
