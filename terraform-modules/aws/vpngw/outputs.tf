output "vpn_connection_id" {
  description = "VPN id"
  value       = module.vpn_gateway[*].vpn_connection_id
}
