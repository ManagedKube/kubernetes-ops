terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.region}"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

# Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.tags}"
}

resource "aws_nat_gateway" "main" {
  count         = "${length(var.availability_zones)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.main"]
  tags          = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "nat" {
  count = "${length(var.availability_zones)}"
  vpc   = true
  tags  = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

# Subnets
resource "aws_subnet" "public" {
  count                   = "${length(var.availability_zones)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.public_cidrs, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "private" {
  count             = "${length(var.availability_zones)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.private_cidrs, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

# Route tables

// Public
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${var.tags}"
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_route_table" "private" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.main.id}"

  tags = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "private" {
  count                  = "${length(var.availability_zones)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index)}"
}

/**
 * Route associations
 */

resource "aws_route_table_association" "private" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"

  lifecycle {
    create_before_destroy = true
  }
}

/**
 * Default security group
 * This gives terraform access to the default security group.
 * See https://www.terraform.io/docs/providers/aws/r/default_security_group.html
 */

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.tags}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "${var.security_group_default_egress}"
  }
}
