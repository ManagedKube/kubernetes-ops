resource "aws_security_group" "sg" {
  name        = "ssm_vpc_endpoint${var.name}"
  description = "An SG for the SSM VPC endpoints"
  vpc_id      = var.aws_vpc_id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = var.ingress_cidr
  }

}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    "${aws_security_group.sg.id}",
  ]

  subnet_ids = var.vpc_endpoint_subnets

  private_dns_enabled = true

  tags = var.tags
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    "${aws_security_group.sg.id}",
  ]

  subnet_ids = var.vpc_endpoint_subnets

  private_dns_enabled = true

  tags = var.tags
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    "${aws_security_group.sg.id}",
  ]

  subnet_ids = var.vpc_endpoint_subnets

  private_dns_enabled = true

  tags = var.tags
}
