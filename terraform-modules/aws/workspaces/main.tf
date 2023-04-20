data "aws_workspaces_bundle" "value_windows_10" {
  bundle_id =  var.bundle_id 
}

resource "aws_workspaces_workspace" "this" {
  for_each = { for workspace in var.workspaces : workspace.user_name => workspace }

  directory_id = aws_workspaces_directory.this.id
  bundle_id    = data.aws_workspaces_bundle.value_windows_10.id
  user_name    = each.value.user_name

  root_volume_encryption_enabled = var.root_volume_encryption_enabled
  user_volume_encryption_enabled = var.user_volume_encryption_enabled
  volume_encryption_key          = var.volume_encryption_key

  workspace_properties {
    compute_type_name                         = each.value.compute_type_name
    user_volume_size_gib                      = each.value.user_volume_size_gib
    root_volume_size_gib                      = each.value.root_volume_size_gib
    running_mode                              = each.value.running_mode
    running_mode_auto_stop_timeout_in_minutes = each.value.running_mode_auto_stop_timeout_in_minutes
  }
  tags = var.tags
}