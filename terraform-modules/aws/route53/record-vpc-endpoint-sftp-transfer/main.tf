
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Get the ARN of the Transfer Server
data "aws_transfer_server" "this" {
  server_id = var.transfer_server_id
}

# Get the VPC Endpoint Service Name for the Transfer Service
data "aws_vpc_endpoint_service" "this" {
  service = "com.amazonaws.${data.aws_region.current.name}.transfer.server.${data.aws_transfer_server.this.id}"
}

# Get the VPC Endpoint ID for the Transfer Service
data "aws_vpc_endpoint" "this" {
  service_name = data.aws_vpc_endpoint_service.this.service_name
  vpc_id       = var.vpc_id
}

module "record" {
  source = "../record/"
  route53_zone_id = var.route53_zone_id
  record_name = var.record_name
  vpc_endpoint_dns_name = data.aws_vpc_endpoint.this.dns_entry[0].dns_name
  vpc_endpoint_zone_id = data.aws_vpc_endpoint.this.dns_entry[0].hosted_zone_id
}