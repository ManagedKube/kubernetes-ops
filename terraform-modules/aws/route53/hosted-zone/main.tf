module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "v2.6.0"

  create = var.create_zones
  zones  = var.zones
  tags   = var.tags
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "v2.6.0"

  create       = var.create_records
  zone_id      = values(module.zones.route53_zone_zone_id)[0]
  zone_name    = values(module.zones.route53_zone_name)[0]
  private_zone = var.private_zone
  records      = var.records
  depends_on   = [module.zones]
}

