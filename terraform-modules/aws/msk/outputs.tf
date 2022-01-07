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