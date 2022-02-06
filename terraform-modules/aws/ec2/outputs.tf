output "id" {
  description = "The ID of the instance"
  value       = try(module.aws_instance.id, "")
}

