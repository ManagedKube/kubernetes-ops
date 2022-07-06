output "kms_arn" {
  description = "Arn of kms for log group of cloudwatch"
  value       = aws_kms_key.kms.arn
}