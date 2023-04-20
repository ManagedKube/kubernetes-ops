output "workspaces_id" {
  description = "The workspaces IDs."
  value       = { for ws in aws_workspaces_workspace.this : ws.user_name => ws.id }
}

output "workspaces_ip_address" {
  description = "The IP addresses of the WorkSpaces."
  value       = { for ws in aws_workspaces_workspace.this : ws.user_name => ws.ip_address }
}

output "workspaces_computer_name" {
  description = "The names of the WorkSpaces, as seen by the operating system."
  value       = { for ws in aws_workspaces_workspace.this : ws.user_name => ws.computer_name }
}

output "workspaces_state" {
  description = "The operational states of the WorkSpaces."
  value       = { for ws in aws_workspaces_workspace.this : ws.user_name => ws.state }
}

output "workspaces_tags_all" {
  description = "A map of tags assigned to the resources, including those inherited from the provider default_tags configuration block."
  value       = { for ws in aws_workspaces_workspace.this : ws.user_name => ws.tags_all }
}
