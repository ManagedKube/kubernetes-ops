terraform {
    backend "s3" {
  }
}

// First account owns the transit gateway and accepts the VPC attachment.
provider "aws" {
    alias = "first"

    region     = "${var.aws_region}"
}

# account #1
resource "aws_ec2_transit_gateway" "transit-gateway" {
    provider = aws.first

    amazon_side_asn = var.amazon_side_asn
    auto_accept_shared_attachments  = var.auto_accept_shared_attachments
    description = var.description
    dns_support = var.dns_support
    vpn_ecmp_support = var.vpn_ecmp_support

    tags = var.tags
}
