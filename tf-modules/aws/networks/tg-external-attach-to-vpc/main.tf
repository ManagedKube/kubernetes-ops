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

// Second account owns the VPC and creates the VPC attachment.
provider "aws" {
    alias = "second"

    region     = var.aws_region
    access_key = var.aws_second_access_key
    secret_key = var.aws_second_secret_key
}

data "aws_availability_zones" "available" {
  provider = "aws.second"

  state = "available"
}

data "aws_caller_identity" "second" {
  provider = "aws.second"
}

resource "aws_ram_resource_share" "resource-share" {
    provider = aws.first
    name                      = "tgw-share-us-west-2-mock"
    allow_external_principals = true
    
    tags = merge(
    {
      "Name" = format("%s-%s", "tg-share", var.name-postfix)
    },
    var.tags,
  )
}

resource "aws_ram_resource_association" "tgw" {
    provider = aws.first
    resource_arn       = var.transit-gateway-arn
    resource_share_arn = aws_ram_resource_share.resource-share.arn
}

resource "aws_ram_principal_association" "principal-association" {
    provider           = aws.first
    principal          = data.aws_caller_identity.second.account_id
    resource_share_arn = aws_ram_resource_share.resource-share.arn
}

# account #2
resource "aws_ram_resource_share_accepter" "resource-share-accepter" {
    provider = aws.second
    share_arn = aws_ram_principal_association.principal-association.resource_share_arn
}

data "aws_vpc" "transit-gateway" {
    provider = "aws.second"
    id = var.vpc_id_second
}

resource "aws_subnet" "transit-gateway" {
  provider = "aws.second"

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
  provider = "aws.second"

  vpc_id = var.vpc_id_second

  tags = merge(
    {
      "Name" = format("%s-%s", "tg-routes", var.name-postfix)
    },
    var.tags,
  )
}

resource "aws_route_table_association" "route-table-association" {
  provider = "aws.second"

  count = length(var.subnets_cidr)

  subnet_id      = aws_subnet.transit-gateway[count.index].id
  route_table_id = aws_route_table.route-table.id
}

// Create the VPC attachment in the second account...
resource "aws_ec2_transit_gateway_vpc_attachment" "transit-gateway" {
  provider = "aws.second"

  depends_on = [aws_ram_principal_association.principal-association, aws_ram_resource_association.tgw, aws_ram_resource_share_accepter.resource-share-accepter]

  subnet_ids         = [
    for num in aws_subnet.transit-gateway:
    num.id
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

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "transit-gateway" {
  provider = "aws.first"

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.transit-gateway]

  transit_gateway_attachment_id = "${aws_ec2_transit_gateway_vpc_attachment.transit-gateway.id}"

  tags = merge(
    {
      "Name" = format("%s-%s", "tg-accepter", var.name-postfix)
    },
    var.tags,
  )
}