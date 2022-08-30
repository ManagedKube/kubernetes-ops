output "iam_arn" {
  description = "Amazon Resource Name (ARN) specifying the role."
  value       = aws_iam_role.this.arn
}