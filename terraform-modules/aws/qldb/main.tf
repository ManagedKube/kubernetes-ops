resource "aws_qldb_ledger" "this" {
  name                = var.name
  permissions_mode    = var.permissions_mode
  deletion_protection = var.deletion_protection
  tags                = var.tags
}
