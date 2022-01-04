resource "aws_iam_openid_connect_provider" "this" {
  url = var.url

  client_id_list = var.client_id_list

  thumbprint_list = var.thumbprint_list

  tags = var.tags
}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = var.name
  provider_url                  = var.url
  role_policy_arns              = [aws_iam_policy.iam_policy.arn]
  oidc_fully_qualified_subjects = var.validate_conditions
  tags                          = var.tags
}

resource "aws_iam_policy" "iam_policy" {
  name_prefix = var.name
  description = "IAM Policy for the Github OIDC Federation permissions"
  policy      = var.aws_policy_json
}
