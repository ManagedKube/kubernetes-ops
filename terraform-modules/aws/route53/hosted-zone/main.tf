locals {
  zone_name = sort(keys(module.zones.route53_zone_zone_id))[0]
  #  zone_id = module.zones.route53_zone_zone_id["app.terraform-aws-modules-example.com"]
}

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

  zone_name = local.zone_name
  #  zone_id = local.zone_id

  create       = var.create_records
  private_zone = var.private_zone
  records      = var.records
  depends_on   = [module.zones]
}

