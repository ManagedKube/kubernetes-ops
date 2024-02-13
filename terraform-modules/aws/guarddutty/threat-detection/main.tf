resource "aws_guardduty_detector" "guardduty_detector" {
  enable = var.guardduty_enabled
}

resource "aws_sns_topic" "guardduty_topic" {
  name = var.sns_topic_name
}

resource "aws_cloudwatch_event_rule" "guardduty_event_rule" {
  name        = var.event_rule_name
  description = var.event_rule_description

  event_pattern = jsonencode({
    "source"      : ["aws.guardduty"],
    "detail-type" : ["GuardDuty Finding"]
  })
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_event_rule.name
  target_id = var.event_target_id

  arn = aws_sns_topic.guardduty_topic.arn
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.guardduty_topic.arn
  protocol  = var.subscription_protocol
  endpoint  = var.subscription_endpoints
}
