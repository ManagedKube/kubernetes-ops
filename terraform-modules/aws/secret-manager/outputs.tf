output "secret_id" {
  description = "Id of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.this.id
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.this.arn
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = var.create_kms_key ? aws_kms_key.this[0].arn : null
}

output "kms_key_id" {
  description = "The globally unique identifier for the KMS key"
  value       = var.create_kms_key ? aws_kms_key.this[0].key_id : null
}
