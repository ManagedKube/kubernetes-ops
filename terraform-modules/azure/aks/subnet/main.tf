# data "azurerm_subnet" "subnet_1" {
#   name                 = "SNET-LB-1"
#   virtual_network_name = "VNET-DEV-EASTUS2-POD301"
#   resource_group_name  = "RG-DEV-EASTUS2-POD301"
# }

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]

}
