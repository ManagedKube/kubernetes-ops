resource "aws_workspaces_ip_group" "users" {
  name        = "Users of AWS Workspaces VDI ${var.account_name}"
  description = "Users IP access control group"
  tags        = var.tags
  
  dynamic "rules" {
    for_each = var.ip_group_rules
    content {
      source      = rules.value.source
      description = rules.value.description
    }
  }
}