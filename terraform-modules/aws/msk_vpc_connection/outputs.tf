output "msk_vpc_connection_arn" {
  description = "ARN of the created AWS MSK VPC Connection"
  value       = aws_msk_vpc_connection.vc.arn
}