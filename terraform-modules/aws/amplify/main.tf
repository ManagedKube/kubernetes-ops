resource "aws_iam_role" "amplify" {
  name = "${var.name}-amplify-role"
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "amplify.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "amplify-policy" {
  name = "${var.name}-amplify-policy"
  policy = templatefile("./default_iam_policy.json", {
    aws_account_id = var.account_id,
    aws_region     = var.aws_region,
    role_name      = "${var.name}-amplify-role"
  })
  tags = var.tags
}
# we have added this policy to resolve the AccessDenied Issue during the Code deployment
# https://github.com/aws-amplify/amplify-hosting/blob/main/FAQ.md#error-accessdenied-access-denied
resource "aws_iam_role_policy_attachment" "amplify-attach-policy" {
  policy_arn = aws_iam_policy.amplify-policy.arn
  role       = aws_iam_role.amplify.name
  tags       = var.tags
}

resource "aws_amplify_app" "amplify" {
  name                     = var.name
  repository               = var.repository_url
  enable_branch_auto_build = var.enable_branch_auto_build
  build_spec               = var.build_spec
  oauth_token              = var.gh_access_token
  iam_service_role_arn     = aws_iam_role.amplify.arn
  dynamic "custom_rule" {
    for_each = var.custom_rules
    content {
      source    = custom_rule.value.source
      target    = custom_rule.value.target
      status    = custom_rule.value.status
      condition = custom_rule.value.condition
    }
  }

  environment_variables = var.environment_variables
  tags                  = var.tags
}

resource "aws_amplify_branch" "deploy_branches" {
  app_id      = aws_amplify_app.amplify.id
  branch_name = var.branch_name
}

resource "aws_amplify_domain_association" "domain" {
  app_id      = aws_amplify_app.amplify.id
  domain_name = var.domain_name

  depends_on = [aws_amplify_branch.deploy_branches]
  sub_domain {
    prefix      = var.sub_domain_prefix
    branch_name = var.sub_domain_branch
  }
}
