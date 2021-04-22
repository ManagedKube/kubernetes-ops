output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}
