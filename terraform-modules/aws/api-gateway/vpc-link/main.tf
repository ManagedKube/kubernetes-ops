resource "aws_lb" "apivpclinknlb" {
  name               = var.load_balancer_name
  internal           = var.internal_lb
  load_balancer_type = var.load_balancer_type

  subnet_mapping {
    subnet_id = var.subnet_id
  }
}

resource "aws_api_gateway_vpc_link" "apivpclink" {
  name        = var.vpc_link_name
  description = var.vpc_link_description
  target_arns = [aws_lb.apivpclinknlb.arn]
}
