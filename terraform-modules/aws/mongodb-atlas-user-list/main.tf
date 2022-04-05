
terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.0.1"
    }
  }
}

resource "mongodbatlas_database_user" "this" {
  count              = length(var.database_users)
  username           = var.database_users[count.index].username
  password           = var.database_users[count.index].create_aws_secret ? aws_secretsmanager_secret_version.this[count.index].secret_string : var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = var.database_users[count.index].auth_database_name

  dynamic "roles" {
    for_each = var.database_users[count.index].roles
    content {
      role_name     = roles.value["role_name"]
      database_name = roles.value["database_name"]
    }
  }
}

################################################
# AWS Secret
#
# Option to add the password into AWS secret
################################################
resource "aws_secretsmanager_secret" "this" {
  count                   = length(var.database_users)
  name                    = var.aws_secret_name
  description             = var.aws_secret_description
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = var.tags
}

resource "random_password" "password" {
  count            = length(var.database_users)
  length           = 16
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  number           = true
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret_version" "this" {
  count         = length(var.database_users)
  secret_id     = aws_secretsmanager_secret.this[0].id
  secret_string = random_password.password[count.index].result
}
