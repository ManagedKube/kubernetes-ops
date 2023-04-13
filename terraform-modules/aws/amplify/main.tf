resource "aws_amplify_app" "amplify" {
  name                     = var.name
  repository               = var.repository_url
  enable_branch_auto_build = var.enable_branch_auto_build
  build_spec               = var.build_spec
  oauth_token              = var.gh_access_token
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
}

resource "aws_amplify_branch" "deploy_branches" {
  app_id      = aws_amplify_app.amplify.id
  branch_name = var.branch_name
}

resource "aws_amplify_domain_association" "example" {
  app_id      = aws_amplify_app.amplify.id
  domain_name = var.domain_name

  sub_domain_setting {
    prefix      = var.sub_domain_prefix
    branch_name = var.sub_domain_branch
  }
}
