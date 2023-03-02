
data "aws_caller_identity" "current" {}

# Get the ARN of the Transfer Server
data "aws_transfer_server" "this" {
  server_id = var.transfer_server_id
}

# Get the VPC Endpoint Service Name for the Transfer Service
data "aws_vpc_endpoint_service" "this" {
  service = "com.amazonaws.${data.aws_caller_identity.current.region}.transfer.server.${data.aws_transfer_server.this.id}"
}

# Get the VPC Endpoint ID for the Transfer Service
data "aws_vpc_endpoint" "this" {
  service_name = data.aws_vpc_endpoint_service.this.service_name
  vpc_id       = var.vpc_id
}

module "record" {
  source = "../record/"
  inputs {
    zone_id = var.route53_zone_id
    name    = var.record_name
    type    = var.type
    alias {
        name                   = data.aws_vpc_endpoint_service.dns_name
        zone_id                = data.aws_vpc_endpoint_service.zone_id
        evaluate_target_health = false
    }
  }
}



