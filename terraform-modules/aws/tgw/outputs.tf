output "tgw_id" {
  description = "The ID of the TGW"
  value       = module.tgw.ec2_transit_gateway_id
}
output "tgw" {
  description = "EC2 Transit Gateway Route Table identifier"
  # value       = module.tgw.ec2_transit_gateway_route_table_id
  value       = module.tgw.*
}
