output "vpc_attachment" {
    description = "Details of the VPC attachment to cloudwan"
    value = resource.aws_networkmanager_vpc_attachment.vpc_attachments.*
}

output "private_routes" {
    value = resource.aws_route.private_route_table[*].id
    description = "Routes added to the public route table"
}

output "public_routes" {
    value = resource.aws_route.public_route_table[*].id
    description = "Routes added to the public route table"
}