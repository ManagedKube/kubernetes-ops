
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


resource "null_resource" "output-vpc-endpoint-id" {
  provisioner "local-exec" {
    command = "aws transfer describe-server --server-id ${var.transfer_server_id} --query 'Server.EndpointDetails.VpcEndpointId' > ${data.template_file.log_name.rendered}"
  }
}

data "template_file" "log_name" {
    template = "${path.module}/output.log"
}

data "local_file" "get-vpc-endpoint-id-value" {
    filename = "${data.template_file.log_name.rendered}"
    depends_on = [null_resource.output-vpc-endpoint-id]
} 

# Get the VPC Endpoint ID for the Transfer Service
data "aws_vpc_endpoint" "this" {
  # Remove quotes
  id = trim(data.local_file.get-vpc-endpoint-id-value.content, "\"")

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