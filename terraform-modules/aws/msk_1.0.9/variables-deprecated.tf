variable "security_groups" {
  type        = list(string)
  default     = []
  description = <<-EOT
  DEPRECATED: Use `allowed_security_group_ids` instead.
  List of security group IDs to be allowed to connect to the cluster
  EOT
}