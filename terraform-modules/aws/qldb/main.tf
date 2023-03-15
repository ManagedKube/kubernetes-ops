resource "aws_qldb_ledger" "this" {
  name                = var.name
  permissions_mode    = var.permissions_mode
  deletion_protection = var.deletion_protection
  kms_key             = var.kms_key
  tags                = var.tags

  vpc_configuration {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.this.id]
  }
}
resource "aws_security_group" "this" {
  name        = var.name
  description = "qldb security group"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}