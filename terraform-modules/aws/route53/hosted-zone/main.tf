module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "v2.5.0"

  create = var.create_zones
  zones  = var.zones
  tags   = var.tags
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "v2.5.0"

  create       = var.create_records
  zone_name    = keys(module.zones.route53_zone_zone_id)[0]
  private_zone = var.private_zone
  records      = var.records
  depends_on   = [module.zones]
}

