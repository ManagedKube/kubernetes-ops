
output "zone_id" {
  description = "Zone ID of Route53 zone"
  value       = values(module.zones.route53_zone_zone_id)[0]
}

output "name_servers" {
  description = "Name servers of Route53 zone"
  value       = module.zones.route53_zone_name_servers
}

output "zone_name" {
  description = "Name of Route53 zone"
  value       = module.zones.route53_zone_name
}

output "route53_record_name" {
  description = "The name of the record"
  value       = module.records.route53_record_name
}

output "route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = module.records.route53_record_fqdn
}

