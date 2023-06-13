resource "aws_api_gateway_vpc_link" "apivpclink" {
  name        = var.vpc_link_name
  description = var.vpc_link_description
  target_arns = [var.vpc_link_nbl_arn]
  tags = var.tags
}
