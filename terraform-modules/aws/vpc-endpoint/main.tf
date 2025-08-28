resource "aws_vpc_endpoint" "this" {
  count               = var.exists == true ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = var.vpc_endpoint_type
  private_dns_enabled = true
}


