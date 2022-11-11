output "cluster_id" {
  value = azurerm_kubernetes_cluster.cluster.id
}

output "client_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate
}

output "kube_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.cluster.kube_config_raw
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.cluster.oidc_issuer_url
}
