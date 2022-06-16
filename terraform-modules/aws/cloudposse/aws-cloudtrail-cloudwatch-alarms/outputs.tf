output "sns_topic_arn" {
  value = module.cis_alarms.sns_topic_arn
}

output "dashboard_individual" {
  value = module.cis_alarms.dashboard_individual
}

output "dashboard_combined" {
  value = module.cis_alarms.dashboard_combined
}