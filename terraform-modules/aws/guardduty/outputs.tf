
output "account_id" {
  value       = aws_guardduty_detector.guardduty_detector.account_id
  description = "The AWS account ID of the GuardDuty detector"
}

output "arn" {
  value       = aws_guardduty_detector.guardduty_detector.arn
  description = "Amazon Resource Name (ARN) of the GuardDuty detector"
}

output "id" {
  value       = aws_guardduty_detector.guardduty_detector.id
  description = "The ID of the GuardDuty detector"
}

