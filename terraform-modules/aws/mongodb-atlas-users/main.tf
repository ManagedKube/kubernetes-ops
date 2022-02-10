
terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.0.1"
    }
  }
}

resource "mongodbatlas_database_user" "admin" {
  username           = var.database_username
  password           = var.create_aws_secret ? aws_secretsmanager_secret_version.this[0].secret_string : var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}

# This user is created from an AWS IAM Role, which is also provisioned by this module
# (see the "AWS Role" section at the end of this file)
# Due to limitations of current MongoDB drivers (see https://jira.mongodb.org/browse/DRIVERS-2011)
# this setup doesn't work as intended as of 2022-02-09, but it is expected to work once
# the MongoDB drivers are updated.
resource "mongodbatlas_database_user" "app_user" {
  username           = aws_iam_role.this.arn
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

# This additional user can be customized with any given AWS IAM Role
# This can be useful when there is the need to use a Role that was created elsewhere
resource "mongodbatlas_database_user" "custom_user" {
  count              = var.create_custom_user ? 1 : 0
  username           = var.custom_user_iam_role
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "$external"
  aws_iam_type       = "ROLE"

  dynamic "roles" {
    for_each = var.custom_user_roles
    content {
      role_name     = roles.value["role_name"]
      database_name = roles.value["database_name"]
    }
  }

  dynamic "labels" {
    for_each = var.custom_user_labels
    content {
      key   = labels.value["key"]
      value = labels.value["value"]
    }
  }

  dynamic "scopes" {
    for_each = var.custom_user_scopes
    content {
      name = scopes.value["name"]
      type = scopes.value["type"]
    }
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

################################################
# AWS role
#
# Using Mongo Atlas IAM authentication.  This would be the role that is given access to the databases.
################################################
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "this" {
  name = "mongo-atlas-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": data.aws_caller_identity.current.account_id
        },
        "Action": "sts:AssumeRole",
        "Condition": {}
      }
    ]
  })

  tags = var.tags
}
