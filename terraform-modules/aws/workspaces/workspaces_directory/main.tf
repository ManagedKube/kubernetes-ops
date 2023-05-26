resource "aws_workspaces_directory" "directory" {
  directory_id = aws_directory_service_directory.directory_service.id
  subnet_ids   = var.workspaces_directory_subnet_ids
  ip_group_ids = var.workspaces_ip_group_ids
  tags = var.tags

  self_service_permissions {
    change_compute_type  = var.self_service_permissions_change_compute_type
    increase_volume_size = var.self_service_permissions_increase_volume_size
    rebuild_workspace    = var.self_service_permissions_rebuild_workspace
    restart_workspace    = var.self_service_permissions_restart_workspace
    switch_running_mode  = var.self_service_permissions_switch_running_mode
  }

  workspace_access_properties {
    device_type_android    = var.workspace_access_properties_device_type_android
    device_type_chromeos   = var.workspace_access_properties_device_type_chromeos
    device_type_ios        = var.workspace_access_properties_device_type_ios
    device_type_linux      = var.workspace_access_properties_device_type_linux
    device_type_osx        = var.workspace_access_properties_device_type_osx
    device_type_web        = var.workspace_access_properties_device_type_web
    device_type_windows    = var.workspace_access_properties_device_type_windows
    device_type_zeroclient = var.workspace_access_properties_device_type_zeroclient
  }

  workspace_creation_properties {
    custom_security_group_id            = var.workspace_creation_properties_custom_security_group_id
    default_ou                          = var.workspace_creation_properties_default_ou
    enable_internet_access              = var.workspace_creation_properties_enable_internet_access
    enable_maintenance_mode             = var.workspace_creation_properties_enable_maintenance_mode
    user_enabled_as_local_administrator = var.workspace_creation_properties_user_enabled_as_local_administrator
  }

  depends_on = [
    aws_iam_role_policy_attachment.workspaces_default_service_access,
    aws_iam_role_policy_attachment.workspaces_default_self_service_access
  ]
}

data "aws_secretsmanager_secret_version" "directory_password" {
  secret_id = var.directory_service_directory_name_password_secretsmanager_id
}

resource "aws_directory_service_directory" "directory_service" {
  name     = var.directory_service_directory_name
  password = data.aws_secretsmanager_secret_version.directory_password.secret_string
  size     = var.directory_service_directory_size
  type     = var.directory_service_directory_type
  edition  = var.directory_service_directory_edition
  enable_sso = var.directory_service_enable_sso

  vpc_settings {
    vpc_id = var.directory_service_directory_vpc_id
    subnet_ids = var.directory_service_directory_subnet_ids
  }
}

data "aws_iam_policy_document" "workspaces" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["workspaces.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "workspaces_default" {
  name               = "workspaces_DefaultRole"
  assume_role_policy = data.aws_iam_policy_document.workspaces.json
}

resource "aws_iam_role_policy_attachment" "workspaces_default_service_access" {
  role       = aws_iam_role.workspaces_default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesServiceAccess"
}

resource "aws_iam_role_policy_attachment" "workspaces_default_self_service_access" {
  role       = aws_iam_role.workspaces_default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesSelfServiceAccess"
}
