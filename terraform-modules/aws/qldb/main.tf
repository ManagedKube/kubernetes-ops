resource "aws_qldb_ledger" "this" {
  name                = var.name
  permissions_mode    = var.permissions_mode
  deletion_protection = var.deletion_protection
  tags                = var.tags
}

resource "aws_security_group" "qldb" {
  name        = "qldb-${var.name}"
  description = "qldb security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rule
    content {
      description      = ingress.value["description"]
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.egress_rule
    content {
      description      = egress.value["description"]
      from_port        = egress.value["from_port"]
      to_port          = egress.value["to_port"]
      protocol         = egress.value["protocol"]
      cidr_blocks      = egress.value["cidr_blocks"]
      ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
    }
  }

  tags = var.tags
}

resource "aws_vpc_endpoint" "qldb" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.us-west-2.qldb.session"
  vpc_endpoint_type   = "Interface"

  security_group_ids  = [aws_security_group.qldb.id]
  subnet_ids          = var.subnet_ids

  private_dns_enabled = true

  tags = var.tags
}