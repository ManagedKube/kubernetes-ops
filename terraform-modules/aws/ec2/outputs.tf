output "id" {
  description = "The ID of the instance"
  value       = try(module.aws_instance.id, "")
}
output "network_interface_id" {
  description = "The ID of the attached network interface"
  value       = try(aws_network_interface.this[0].id, "")
}

