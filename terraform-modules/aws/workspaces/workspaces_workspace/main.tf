data "aws_caller_identity" "current" {}

resource "aws_kms_key" "workspace" {
  for_each = { for workspace in var.workspaces : workspace.user_name => workspace }
  description             = "KMS key for AWS Workspaces ${each.value.user_name}"
  deletion_window_in_days = 30
  key_usage               = "ENCRYPT_DECRYPT"
  is_enabled              = true
  enable_key_rotation     = true

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "KMS-Workspaces-${each.value.user_name}",
    "Statement": [
      {
        "Sid": "AllowUseOfTheKey",
        "Effect": "Allow",
        "Principal": {"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"},
        "Action": "kms:*",
        "Resource": "*"
      }
    ]
  }
  POLICY
}

resource "aws_kms_alias" "workspace_alias" {
  for_each          = { for workspace in var.workspaces : workspace.user_name => workspace }
  name              = "alias/workspaces-${replace(each.value.user_name, ".", "")}"
  target_key_id     = aws_kms_key.workspace[each.key].key_id
}

data "aws_workspaces_bundle" "value_windows_10" {
  bundle_id =  var.bundle_id 
}

resource "aws_workspaces_workspace" "this" {
  for_each = { for workspace in var.workspaces : workspace.user_name => workspace }

  directory_id = var.workspaces_directory_id
  bundle_id    = data.aws_workspaces_bundle.value_windows_10.id
  user_name    = each.value.user_name

  root_volume_encryption_enabled = var.root_volume_encryption_enabled
  user_volume_encryption_enabled = var.user_volume_encryption_enabled
  volume_encryption_key          = aws_kms_key.workspace[each.key].arn

  workspace_properties {
    compute_type_name                         = each.value.compute_type_name
    user_volume_size_gib                      = each.value.user_volume_size_gib
    root_volume_size_gib                      = each.value.root_volume_size_gib
    running_mode                              = each.value.running_mode
    running_mode_auto_stop_timeout_in_minutes = each.value.running_mode_auto_stop_timeout_in_minutes
  }
  tags = var.tags
  timeouts {
    create = "60m"
  }
}