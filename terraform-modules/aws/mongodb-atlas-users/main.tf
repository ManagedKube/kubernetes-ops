
terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.0.1"
    }
  }
}

resource "mongodbatlas_database_user" "admin" {
  username           = "admin"
  password           = var.create_aws_secret ? aws_secretsmanager_secret_version.this[0].secret_string : var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}

resource "mongodbatlas_database_user" "test" {
  username           = var.iam_role_name
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "$external"
  aws_iam_type       = "ROLE"

  roles {
    role_name     = "readAnyDatabase"
    database_name = "admin"
  }

  labels {
    key   = "%s"
    value = "%s"
  }

  scopes {
    name = var.cluster_name
    type = "CLUSTER"
  }
}

################################################
# AWS Secret
#
# Option to add the password into AWS secret
################################################
resource "aws_secretsmanager_secret" "this" {
  count                   = var.create_aws_secret ? 1 : 0
  name                    = var.aws_secret_name
  description             = var.aws_secret_description
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = var.tags
}

resource "random_password" "password" {
  count            = var.create_aws_secret ? 1 : 0
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
  count         = var.create_aws_secret ? 1 : 0
  secret_id     = aws_secretsmanager_secret.this[0].id
  secret_string = random_password.password[0].result
}
