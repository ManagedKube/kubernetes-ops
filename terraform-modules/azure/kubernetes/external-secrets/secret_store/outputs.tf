output "app_client_id" {
  value = azuread_application.app.application_id
}

output "k8s_service_account_name" {
  value = "secret-store-${local.base_name}-${var.environment_name}"
}
