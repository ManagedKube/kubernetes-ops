resource "aws_cloudwatch_log_group" "msk_cloudwatch_log_group" {
  name = var.cloudwatch_logs_log_group
  tags = var.tags
}

# module "msk_log_bucket" {
#   source                  = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/s3_bucket?ref=v1.0.55"
#   bucket                  = var.s3_logs_bucket
#   acl                     = "private"
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

module "msk" {
  source                         = "cloudposse/msk-apache-kafka-cluster/aws"
  version                        = "v0.8.3"
  namespace                      = var.namespace
  name                           = var.name
  vpc_id                         = var.vpc_id
  client_broker                  = var.client_broker
  zone_id                        = var.zone_id
  security_groups                = var.security_groups
  subnet_ids                     = var.subnet_ids
  kafka_version                  = var.kafka_version
  number_of_broker_nodes         = var.number_of_broker_nodes
  broker_instance_type           = var.broker_instance_type
  broker_volume_size             = var.broker_volume_size
  tags                           = var.tags
  certificate_authority_arns     = var.certificate_authority_arns
  client_tls_auth_enabled        = var.client_tls_auth_enabled
  encryption_in_cluster          = var.encryption_in_cluster
  encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn
  cloudwatch_logs_enabled        = var.cloudwatch_logs_enabled
  cloudwatch_logs_log_group      = var.cloudwatch_logs_enabled == true ? var.cloudwatch_logs_log_group : ""
  enhanced_monitoring            = var.enhanced_monitoring
  node_exporter_enabled          = var.node_exporter_enabled
  s3_logs_bucket                 = var.s3_logs_enabled == true ? var.s3_logs_bucket : ""
  s3_logs_enabled                = var.s3_logs_enabled
  s3_logs_prefix                 = var.s3_logs_enabled == true ? var.s3_logs_prefix : ""

  depends_on = [
    aws_cloudwatch_log_group.msk_cloudwatch_log_group,
#     module.msk_log_bucket
  ]
}


