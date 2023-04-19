# Creates the KMS key only when the create_kms_key variable is set to false.
resource "aws_kms_key" "this" {
  count                   = var.create_kms_key ? 1 : 0
  description             = var.secretsmanager_kms_name
  deletion_window_in_days = var.secretsmanager_kms_deletion_window_in_days
  tags                    = var.tags
}

resource "aws_kms_alias" "a" {
  count         = var.create_kms_key ? 1 : 0
  name          = "alias/${var.secretsmanager_kms_name_alias}"
  target_key_id = aws_kms_key.this[0].key_id
}

# Creates the Secrets Manager secret.
resource "aws_secretsmanager_secret" "this" {
  name                      = var.secretsmanager_secret_name
  description               = var.secretsmanager_secret_description
  recovery_window_in_days   = var.secretsmanager_secret_recovery_window_in_days
  
  #If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager
  kms_key_id                = var.create_kms_key ? aws_kms_key.this[0].id : null
  
  tags                      = var.tags
}