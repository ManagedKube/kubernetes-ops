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
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  value       = element(concat(aws_eks_cluster.*.id, list("")), 0)
  # So that calling plans wait for the cluster to be available before attempting
  # to use it. They will not need to duplicate this null_resource
  depends_on = [null_resource.wait_for_cluster]
}
