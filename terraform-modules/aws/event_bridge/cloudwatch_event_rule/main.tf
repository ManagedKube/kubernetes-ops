resource "aws_cloudwatch_event_rule" "guardduty_event_rule" {
  name        = var.event_rule_name
  description = var.event_rule_description

  event_pattern = var.event_pattern
}