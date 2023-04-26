output "workspaces_id" {
  description = "Id - The IP group identifier."
  value       = { for ws in aws_workspaces_workspace.this : ws.user_name => ws.id }
}