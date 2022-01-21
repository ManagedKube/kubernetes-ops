output "private_link_id" {
  value = mongodbatlas_privatelink_endpoint.mongodbatlas.id
}

output "endpoint_service_name" {
  value = aws_vpc_endpoint.mongodbatlas.service_name
}

output "status" {
  value = mongodbatlas_privatelink_endpoint.mongodbatlas.status
}

output "name" {
  value = mongodbatlas_cluster.cluster.name
}

output "service_endpoint_dns" {
  value = aws_vpc_endpoint.mongodbatlas.dns_entry[0]["dns_name"]
}

# https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cluster#example---return-a-connection-string
output "connect_string_aws_private_endpoint" {
    value = lookup(mongodbatlas_cluster.cluster-test.connection_strings[0].private_endpoint[0].srv_connection_string, aws_vpc_endpoint.ptfe_service.id)
}

output "connect_string_standard" {
    value = mongodbatlas_cluster.cluster-test.connection_strings[0].standard
}
