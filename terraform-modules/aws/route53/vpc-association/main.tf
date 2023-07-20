# resource "aws_route53_zone_association" "this" {
#   for_each = var.vpc_id
#   vpc_id   = each.value
#   zone_id  = var.route53_hosted_zone_id
# }
resource "aws_route53_zone_association" "this" {
  for_each = var.vpc_id
  vpc_id   = each.value.id
  vpc_region = each.value.region
  zone_id = var.route53_hosted_zone_id

  dynamic "vpc" {
    for_each = try([each.value], [])
    content {
      vpc_id     = vpc.value.id
      vpc_region = vpc.value.region
    }
  }
}
