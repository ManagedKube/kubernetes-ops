output "vpn_connection_arn" {
  value = aws_vpn_connection.main.*.arn
}