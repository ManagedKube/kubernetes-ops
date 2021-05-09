output "kubernetes_persistent_volume_claim_name" {
  value       = var.efs_name
  description = "Name of the pvc claim"
}

output "kubernetes_persistent_volume_name" {
  value = var.efs_name
}