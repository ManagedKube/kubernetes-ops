# resource "azurerm_resource_group" "example" {
#   name     = "example-resources"
#   location = "West Europe"
# }

data "azurerm_resource_group" "this" {
  name = var.azurerm_resource_group
}

resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.azurerm_resource_group
  location            = azurerm_resource_group.this.location
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
    key_vault_key_id   = data.azurerm_key_vault_key.example.id
    identity_client_id = azurerm_user_assigned_identity.this.client_id
  }

}

resource "azurerm_user_assigned_identity" "this" {
  resource_group_name = var.azurerm_resource_group
  location            = azurerm_resource_group.this.location

  name = "registry-uai"
}

data "azurerm_key_vault_key" "example" {
  name         = "container-registry-${var.name}"
  key_vault_id = var.key_vault_id
}
