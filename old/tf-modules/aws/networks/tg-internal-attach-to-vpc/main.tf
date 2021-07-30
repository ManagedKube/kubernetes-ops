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

data "aws_caller_identity" "second" {
  provider = "aws.first"
}

data "aws_vpc" "transit-gateway" {
    provider = "aws.first"
    id = var.vpc_id_first
}

resource "aws_subnet" "transit-gateway" {
  provider = "aws.first"

  count = length(var.subnets_cidr)

  availability_zone = var.availability_zone[count.index]
  cidr_block        = var.subnets_cidr[count.index]
  vpc_id            = data.aws_vpc.transit-gateway.id

  tags = merge(
    {
      "Name" = format("%s-%s", "tg-subnet", var.name-postfix)
    },
    var.tags,
  )
}

resource "aws_route_table" "route-table" {
  provider = "aws.first"

  vpc_id = var.vpc_id_first

  tags = merge(
    {
      "Name" = format("%s-%s", "tg-routes", var.name-postfix)
    },
    var.tags,
  )
}

resource "aws_route_table_association" "route-table-association" {
  provider = "aws.first"

  count = length(var.subnets_cidr)

  subnet_id      = aws_subnet.transit-gateway[count.index].id
  route_table_id = aws_route_table.route-table.id
}

// Create the VPC attachment in the second account...
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
