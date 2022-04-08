module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "v4.18.0"

  trusted_role_arns = var.trusted_role_arns

  create_role       = var.create_role
  role_name         = var.role_name
  role_requires_mfa = var.role_requires_mfa
  role_sts_externalid = var.role_sts_externalid

  custom_role_policy_arns           = var.custom_role_policy_arns
  number_of_custom_role_policy_arns = var.number_of_custom_role_policy_arns
}


