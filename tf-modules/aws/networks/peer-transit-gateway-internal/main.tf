terraform {
    backend "s3" {
  }
}

// First account owns the transit gateway and accepts the VPC attachment.
provider "aws" {
    alias = "first"

    region     = var.aws_region
    access_key = var.aws_first_access_key
    secret_key = var.aws_first_secret_key
}

// Create the transit gateway attachment in the second account...
resource "aws_ec2_transit_gateway_vpc_attachment" "transit-gateway" {
  provider = "aws.first"

  subnet_ids         = [
    for item in aws_subnet.transit-gateway:
    item.id
  ]
  transit_gateway_id = var.transit-gateway-id
  vpc_id             = data.aws_vpc.transit-gateway.id

  tags = merge(
    {
      "Name" = format("%s-%s", "tg-att", var.name-postfix)
    },
    var.tags,
  )
}
