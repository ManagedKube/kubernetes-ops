
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "null_resource" "extract_vpc_endpoint_id" {
  provisioner "local-exec" {
    command = "aws transfer describe-server --server-id ${var.transfer_server_id} --query 'Server.EndpointDetails.VpcEndpointId' --output text"

    environment = {
      AWS_REGION = data.aws_region.current.name
    }
  }
}

# Get the VPC Endpoint ID for the Transfer Service
data "aws_vpc_endpoint" "this" {
  id = data.null_resource.extract_vpc_endpoint_id.stdout

  depends_on = [
    null_resource.extract_vpc_endpoint_id
  ]
}

module "record" {
  source = "../record/"
  route53_zone_id = var.route53_zone_id
  record_name = var.record_name
  vpc_endpoint_dns_name = data.aws_vpc_endpoint.this.dns_entry[0].dns_name
  vpc_endpoint_zone_id = data.aws_vpc_endpoint.this.dns_entry[0].hosted_zone_id

  depends_on = [
    data.aws_vpc_endpoint.this
  ]
}