resource "aws_route53_record" "this" {
  zone_id = var.route53_zone_id
  name    = var.record_name
  type    = var.type
  alias {
    name                   = var.vpc_endpoint_dns_name
    zone_id                = var.vpc_endpoint_zone_id
    evaluate_target_health = false
  }
}