output "arn" {
  value = module.iam_assumable_role.iam_role_arn
}

output "name" {
  value = module.iam_assumable_role.iam_role_name
}