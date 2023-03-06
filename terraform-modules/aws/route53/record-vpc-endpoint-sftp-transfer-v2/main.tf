
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "terraform_remote_state" "this" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket_name
    key    = var.tf_state_path
    region = var.tf_state_region
  }
}

# Get the VPC Endpoint ID for the Transfer Service
data "aws_vpc_endpoint" "this" {
  # Remove quotes and new lines
  id = data.terraform_remote_state.this.aws_transfer_server.default.instances.0.attributes.endpoint_details.0.vpc_endpoint_id
  vpc_id = var.vpc_id

  depends_on = [
    data.local_file.get-vpc-endpoint-id-value
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