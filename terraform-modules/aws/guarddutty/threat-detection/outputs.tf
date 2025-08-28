output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = aws_sns_topic.guardduty_topic.arn
}
