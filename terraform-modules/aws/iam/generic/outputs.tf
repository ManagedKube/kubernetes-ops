output "iam_arn" {
  description = "Amazon Resource Name (ARN) specifying the role."
  value       = aws_iam_role.this.arn
}

output "iam_instance_profile_arn" {
  description = "Amazon Resource Name (ARN) specifying instance profiel the role."
  value       = aws_iam_instance_profile.this[0].arn
}