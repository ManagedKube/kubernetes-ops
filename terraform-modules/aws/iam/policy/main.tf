module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "v4.18.0"

  create_policy = var.create_policy
  name          = var.policy_name
  path          = var.policy_path
  description   = var.policy_description

  policy = var.policy
}
