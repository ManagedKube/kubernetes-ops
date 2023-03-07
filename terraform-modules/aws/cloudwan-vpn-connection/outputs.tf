output "vpn_connection_arn" {
  value = [for my_arn in aws_vpn_connection.main: my_arn.arn]
  sensitive = false
}