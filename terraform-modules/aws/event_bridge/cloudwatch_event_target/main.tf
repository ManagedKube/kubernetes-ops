resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_event_rule.name
  target_id = var.event_target_id

  arn = aws_sns_topic.guardduty_topic.arn
}