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