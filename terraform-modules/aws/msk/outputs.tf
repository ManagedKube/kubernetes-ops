output "cluster_name" {
  description = "MSK Cluster name"
  value       = module.msk.cluster_name
}

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = module.msk.cluster_arn
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster"
  value       = module.msk.zookeeper_connect_string
}

output "bootstrap_brokers" {
  description = "A comma separated list of one or more hostname:port pairs of kafka brokers suitable to boostrap connectivity to the kafka cluster"
  value       = module.msk.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity to the kafka cluster"
  value       = module.msk.bootstrap_brokers_tls
}

output "bootstrap_brokers_scram" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity using SASL/SCRAM to the kafka cluster."
  value       = module.msk.bootstrap_brokers_scram
}

output "bootstrap_brokers_iam" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity using SASL/IAM to the kafka cluster."
  value       = module.msk.bootstrap_brokers_iam
}

output "all_brokers" {
  description = "A list of all brokers"
  value       = module.msk.all_brokers
}

output "current_version" {
  description = "Current version of the MSK Cluster used for updates"
  value       = module.msk.current_version
}

output "config_arn" {
  description = "Amazon Resource Name (ARN) of the configuration"
  value       = module.msk.config_arn
}

output "latest_revision" {
  description = "Latest revision of the configuration"
  value       = module.msk.latest_revision
}

output "hostname" {
  description = "Comma separated list of one or more MSK Cluster Broker DNS hostname"
  value       = module.msk.hostname
}

output "security_group_id" {
  description = "The ID of the security group rule"
  value       = module.msk.security_group_id
}

output "security_group_name" {
  description = "The name of the security group rule"
  value       = module.msk.security_group_name
}