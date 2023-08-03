locals {
  hosted_zones = var.hosted_zone

  zone_associations = flatten([
    for zone_name, zone_data in local.hosted_zones : [
      for vpc in zone_data.vpc : {
        zone_id     = zone_data.zone_id
        vpc_id      = vpc.vpc_id
        vpc_region  = vpc.vpc_region
        zone_name   = zone_name
      }
    ]
  ])
}

resource "aws_route53_zone_association" "this" {
  for_each = { for assoc in local.zone_associations : "${assoc.zone_id}-${assoc.vpc_id}" => assoc }

  zone_id    = each.value.zone_id
  vpc_id     = each.value.vpc_id
  vpc_region = each.value.vpc_region
}
