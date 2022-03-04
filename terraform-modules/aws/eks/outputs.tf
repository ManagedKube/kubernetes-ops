output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_platform_version" {
  value = module.eks.cluster_platform_version
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

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}
  
output "eks_managed_node_groups_arns" {
  value = [
    for item in module.eks.eks_managed_node_groups:
    {
      rolearn  = item.iam_role_arn
    }
  ]
}

