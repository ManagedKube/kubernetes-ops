output "virtual_private_gateway_id" {
    value = resource.aws_vpn_gateway.vpn_gw.id
}

output "virtual_private_gateway_arn" {
    value = resource.aws_vpn_gateway.vpn_gw.arn
}

output "VPN_connections" {
    value = resource.aws_vpn_connection.main[*]
    sensitive = true
  
}