# resource "aws_route53_zone_association" "this" {
#   for_each = var.vpc_id
#   vpc_id   = each.value
#   zone_id  = var.route53_hosted_zone_id
# }

resource "aws_route53_zone_association" "this" {
  for_each = var.hosted_zone

  zone_id  = lookup(each.value, "zone_id", each.key)
  vpc_id   = lookup(each.value, "vpc_id", null)

  dynamic "vpc" {
    for_each = try(tolist(lookup(each.value, "vpc", [])), [lookup(each.value, "vpc", {})])

    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = lookup(vpc.value, "vpc_region", null)
    }
  }
}