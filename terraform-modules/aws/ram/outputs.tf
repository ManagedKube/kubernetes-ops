output "resource_share" {
  description = "Object with the AWS RAM resource share resource"
  value       = aws_ram_resource_share.this
}

output "resource_associations" {
  description = "Object with the AWS RAM resource associations resources"
  value       = module.resource_associations
}

output "principal_associations" {
  description = "Object with the AWS RAM principal associations resources"
  value       = module.principal_associations
}
