resource "azuread_group" "this" {
  count                = length(var.groups)

  display_name     = var.groups[count.index].display_name
  owners           = var.groups[count.index].owners
  security_enabled = var.groups[count.index].security_enabled

  members          = var.groups[count.index].members
}
