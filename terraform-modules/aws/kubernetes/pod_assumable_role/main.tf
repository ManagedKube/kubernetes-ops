module "iam_assumable_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.20.3"
  create_role                   = true
  role_name                     = var.name
  provider_url                  = replace(var.eks_cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = concat(var.iam_policy_arns, [aws_iam_policy.iam_policy.arn])
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.k8s_namespace}:${var.name}"]
  tags                          = var.tags
}

resource "aws_iam_policy" "iam_policy" {
  name_prefix = var.name
  description = var.iam_policy_description
  policy      = var.iam_policy_json
  tags        = var.tags
}
