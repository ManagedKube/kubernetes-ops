resource "aws_route53_zone_association" "this" {
  for_each = var.vpc_id
  vpc_id = each.value
  zone_id = var.route53_hosted_zone_id
}
