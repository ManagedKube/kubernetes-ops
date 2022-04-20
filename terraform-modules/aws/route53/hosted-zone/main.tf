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
  #
  # Using zone_name does not work. Use zone_id instead.
  # Error: no matching Route53Zone found
  #   with module.records.data.aws_route53_zone.this[0],
  #   on .terraform/modules/records/modules/records/main.tf line 23, in data "aws_route53_zone" "this":
  #   23: data "aws_route53_zone" "this" {
  #
  # zone_name    = keys(module.zones.route53_zone_zone_id)[0] 
  private_zone = var.private_zone
  records      = var.records
  depends_on   = [module.zones]
}

