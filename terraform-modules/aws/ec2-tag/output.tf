output "instance_tags" {
  value = var.account_tags[data.aws_caller_identity.current.account_id]
}