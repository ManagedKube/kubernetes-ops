output "execute_api_endpoint_id" {
  value = aws_vpc_endpoint.execute_api_endpoint.id
}

output "execute_api_endpoint_network_interface_ids" {
  value = aws_vpc_endpoint.execute_api_endpoint.network_interface_ids
}

output "execute_api_ips" {
  value = [for nic in data.aws_network_interface.execute_api_nics : nic.private_ip]
}