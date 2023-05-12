output "workspaces_ip_group_id" {
  description = "The IP group identifier."
  value       = aws_workspaces_ip_group.users.id
}