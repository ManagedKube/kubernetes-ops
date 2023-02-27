output "principal_association" {
  description = "Object with the AWS RAM principal association resource"
  value       = module.principal_association.principal_association
}

output "share_accepter" {
  description = "Object with the AWS RAM share accepter resource"
  value       = module.accepter.share_accepter
}
