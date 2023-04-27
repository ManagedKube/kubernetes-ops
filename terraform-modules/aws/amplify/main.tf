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

# Base policy for Amplify app allows access to resources needed by Amplify applications.
# https://docs.aws.amazon.com/amplify/latest/userguide/security-iam-awsmanpol.html?authuser=1
resource "aws_iam_role_policy_attachment" "role_attach" {
  role       = aws_iam_role.amplify.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-Amplify"
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
