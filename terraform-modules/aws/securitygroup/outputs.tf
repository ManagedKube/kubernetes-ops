output "id" {
  value = aws_security_group.sg.id
  description = "ID of the security group."
}

output "arn" {
  value = aws_security_group.sg.arn
  description = "ARN of the security group."
}

output "name" {
  value = aws_security_group.sg.name
  description = "The name of the security group"
}