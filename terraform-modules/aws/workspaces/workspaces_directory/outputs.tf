output "workspace_directory_id" {
  description = "The WorkSpaces directory identifier."
  value       = aws_workspaces_directory.directory.id
}

output "workspace_directory_alias" {
  description = "The directory alias."
  value       = aws_workspaces_directory.directory.alias
}

output "workspace_directory_customer_user_name" {
  description = "The user name for the service account."
  value       = aws_workspaces_directory.directory.customer_user_name
}

output "workspace_directory_directory_name" {
  description = "The name of the directory."
  value       = aws_workspaces_directory.directory.directory_name
}

output "workspace_directory_directory_type" {
  description = "The directory type."
  value       = aws_workspaces_directory.directory.directory_type
}

output "workspace_directory_dns_ip_addresses" {
  description = "The IP addresses of the DNS servers for the directory."
  value       = aws_workspaces_directory.directory.dns_ip_addresses
}

output "workspace_directory_iam_role_id" {
  description = "The identifier of the IAM role."
  value       = aws_workspaces_directory.directory.iam_role_id
}

output "workspace_directory_ip_group_ids" {
  description = "The identifiers of the IP access control groups associated with the directory."
  value       = aws_workspaces_directory.directory.ip_group_ids
}

output "workspace_directory_registration_code" {
  description = "The registration code for the directory."
  value       = aws_workspaces_directory.directory.registration_code
}

output "workspace_directory_tags_all" {
  description = "A map of tags assigned to the resource."
  value       = aws_workspaces_directory.directory.tags_all
}

output "workspace_directory_workspace_security_group_id" {
  description = "The identifier of the security group that is assigned to new WorkSpaces."
  value       = aws_workspaces_directory.directory.workspace_security_group_id
}
