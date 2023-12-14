output "cluster_arn" {
  value       = one(aws_msk_cluster.default[*].arn)
  description = "Amazon Resource Name (ARN) of the MSK cluster"
}

output "cluster_name" {
  value       = one(aws_msk_cluster.default[*].cluster_name)
  description = "MSK Cluster name"
}

output "storage_mode" {
  value       = one(aws_msk_cluster.default[*].storage_mode)
  description = "Storage mode for supported storage tiers"
}

output "bootstrap_brokers" {
  value       = one(aws_msk_cluster.default[*].bootstrap_brokers)
  description = "Comma separated list of one or more hostname:port pairs of Kafka brokers suitable to bootstrap connectivity to the Kafka cluster"
}

output "bootstrap_brokers_tls" {
  value       = one(aws_msk_cluster.default[*].bootstrap_brokers_tls)
  description = "Comma separated list of one or more DNS names (or IP addresses) and TLS port pairs for access to the Kafka cluster using TLS"
}

output "bootstrap_brokers_public_tls" {
  value       = one(aws_msk_cluster.default[*].bootstrap_brokers_public_tls)
  description = "Comma separated list of one or more DNS names (or IP addresses) and TLS port pairs for public access to the Kafka cluster using TLS"
}

output "bootstrap_brokers_sasl_scram" {
  value       = one(aws_msk_cluster.default[*].bootstrap_brokers_sasl_scram)
  description = "Comma separated list of one or more DNS names (or IP addresses) and SASL SCRAM port pairs for access to the Kafka cluster using SASL/SCRAM"
}

output "bootstrap_brokers_public_sasl_scram" {
  value       = one(aws_msk_cluster.default[*].bootstrap_brokers_public_sasl_scram)
  description = "Comma separated list of one or more DNS names (or IP addresses) and SASL SCRAM port pairs for public access to the Kafka cluster using SASL/SCRAM"
}

output "bootstrap_brokers_sasl_iam" {
  value       = one(aws_msk_cluster.default[*].bootstrap_brokers_sasl_iam)
  description = "Comma separated list of one or more DNS names (or IP addresses) and SASL IAM port pairs for access to the Kafka cluster using SASL/IAM"
}

output "bootstrap_brokers_public_sasl_iam" {
  value       = one(aws_msk_cluster.default[*].bootstrap_brokers_public_sasl_iam)
  description = "Comma separated list of one or more DNS names (or IP addresses) and SASL IAM port pairs for public access to the Kafka cluster using SASL/IAM"
}

output "zookeeper_connect_string" {
  value       = one(aws_msk_cluster.default[*].zookeeper_connect_string)
  description = "Comma separated list of one or more hostname:port pairs to connect to the Apache Zookeeper cluster"
}

output "zookeeper_connect_string_tls" {
  value       = one(aws_msk_cluster.default[*].zookeeper_connect_string_tls)
  description = "Comma separated list of one or more hostname:port pairs to connect to the Apache Zookeeper cluster via TLS"
}

output "broker_endpoints" {
  value       = local.broker_endpoints
  description = "List of broker endpoints"
}

output "current_version" {
  value       = one(aws_msk_cluster.default[*].current_version)
  description = "Current version of the MSK Cluster"
}

output "config_arn" {
  value       = one(aws_msk_configuration.config[*].arn)
  description = "Amazon Resource Name (ARN) of the MSK configuration"
}

output "latest_revision" {
  value       = one(aws_msk_configuration.config[*].latest_revision)
  description = "Latest revision of the MSK configuration"
}

output "hostnames" {
  value       = module.hostname[*].hostname
  description = "List of MSK Cluster broker DNS hostnames"
}

output "security_group_id" {
  value       = module.security_group.id
  description = "The ID of the created security group"
}

output "security_group_arn" {
  value       = module.security_group.arn
  description = "The ARN of the created security group"
}

output "security_group_name" {
  value = module.security_group.name
}

output "cluster_uuid" {
  description = "UUID of the MSK cluster, for use in IAM policies"
  value = one(aws_msk_cluster.default[*].cluster_uuid)
}