output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

# output "cluster_version" {
#   value = module.eks.cluster_version
# }
output "cluster_platform_version" {
  description = "Platform version for the cluster"
  value       = module.eks.cluster_platform_version
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

# output "worker_security_group_id" {
#   value = module.eks.worker_security_group_id
# }

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "aws_auth_configmap_yaml" {
  value = module.eks.aws_auth_configmap_yaml
}
