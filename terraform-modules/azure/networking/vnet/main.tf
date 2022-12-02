data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_network_security_group" "this" {
  name                = "${var.vnet_name}-main"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
        name                       = security_rule.value["name"]
        priority                   = security_rule.value["priority"]
        direction                  = security_rule.value["direction"]
        access                     = security_rule.value["access"]
        protocol                   = security_rule.value["protocol"]
        source_port_range          = security_rule.value["source_port_range"]
        destination_port_range     = security_rule.value["destination_port_range"]
        source_address_prefix      = security_rule.value["source_address_prefix"]
        destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
  }

  tags = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  dynamic "subnet" {
    for_each = var.subnets
    content {
        name            = subnet.value["name"]
        address_prefix  = subnet.value["address_prefix"]
        security_group  = azurerm_network_security_group.this.id
    }
  }

  tags = var.tags
}
