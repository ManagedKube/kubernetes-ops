module "cgw" {
  source  = "terraform-aws-modules/customer-gateway/aws"
  version = "~> 2.0"

  create = var.create_cgw
  name = var.cgw_name

  customer_gateways = var.customer_gateways

  tags = var.tags
}