resource "aws_iam_role" "this" {
  name                  = var.iam_name  
  description           = var.iam_description
  force_detach_policies = var.iam_force_detach_policies
  max_session_duration  = var.iam_max_session_duration
  inline_policy         = var.iam_inline_policy
  managed_policy_arns   = var.iam_managed_policy_arns
  tags                  = var.tags
}