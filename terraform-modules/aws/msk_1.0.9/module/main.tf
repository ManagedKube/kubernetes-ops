locals {
  enabled = module.this.enabled

  #broker_endpoints = local.enabled ? flatten(data.aws_msk_broker_nodes.default[0].node_info_list[*].endpoints) : []
  broker_endpoints = local.enabled && length(data.aws_msk_broker_nodes.default) > 0 ? flatten(data.aws_msk_broker_nodes.default[0].node_info_list[*].endpoints) : []

  # If var.storage_autoscaling_max_capacity is not set, don't autoscale past current size
  broker_volume_size_max = coalesce(var.storage_autoscaling_max_capacity, var.broker_volume_size)

  # var.client_broker types
  plaintext     = "PLAINTEXT"
  tls_plaintext = "TLS_PLAINTEXT"
  tls           = "TLS"

  # The following ports are not configurable. See: https://docs.aws.amazon.com/msk/latest/developerguide/client-access.html#port-info
  protocols = {
    plaintext = {
      name = "plaintext"
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#bootstrap_brokers
      enabled = contains([local.plaintext, local.tls_plaintext], var.client_broker)
      port    = 9092
    }
    tls = {
      name = "TLS"
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#bootstrap_brokers_tls
      enabled = contains([local.tls_plaintext, local.tls], var.client_broker)
      port    = 9094
    }
    sasl_scram = {
      name = "SASL/SCRAM"
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#bootstrap_brokers_sasl_scram
      enabled = var.client_sasl_scram_enabled && contains([local.tls_plaintext, local.tls], var.client_broker)
      port    = 9096
    }
    sasl_iam = {
      name = "SASL/IAM"
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#bootstrap_brokers_sasl_iam
      enabled = var.client_sasl_iam_enabled && contains([local.tls_plaintext, local.tls], var.client_broker)
      port    = 9098
    }
    # The following two protocols are always enabled.
    # See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#zookeeper_connect_string
    # and https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#zookeeper_connect_string_tls
    zookeeper_plaintext = {
      name    = "Zookeeper plaintext"
      enabled = true
      port    = 2181
    }
    zookeeper_tls = {
      name    = "Zookeeper TLS"
      enabled = true
      port    = 2182
    }
    # The following two protocols are enabled on demand of user
    # See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#jmx_exporter
    # and https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#node_exporter
    # and https://docs.aws.amazon.com/msk/latest/developerguide/open-monitoring.html#set-up-prometheus-host
    jmx_exporter = {
      name    = "JMX Exporter"
      enabled = var.jmx_exporter_enabled
      port    = 11001
    }
    node_exporter = {
      name    = "Node Exporter"
      enabled = var.node_exporter_enabled
      port    = 11002
    }
  }
}

data "aws_msk_broker_nodes" "default" {
  count = local.enabled ? 1 : 0

  cluster_arn = one(aws_msk_cluster.default[*].arn)
}

# https://github.com/cloudposse/terraform-aws-security-group/blob/master/docs/migration-v1-v2.md
module "security_group" {
  source  = "cloudposse/security-group/aws"
  version = "2.1.0"

  enabled = local.enabled && var.create_security_group

  vpc_id = var.vpc_id

  security_group_name           = var.security_group_name
  create_before_destroy         = var.security_group_create_before_destroy
  preserve_security_group_id    = var.preserve_security_group_id
  security_group_create_timeout = var.security_group_create_timeout
  security_group_delete_timeout = var.security_group_delete_timeout
  security_group_description    = var.security_group_description
  allow_all_egress              = var.allow_all_egress
  rules                         = var.additional_security_group_rules
  inline_rules_enabled          = var.inline_rules_enabled

  rule_matrix = [
    {
      source_security_group_ids = var.allowed_security_group_ids
      cidr_blocks               = var.allowed_cidr_blocks
      rules = [
        for protocol_key, protocol in local.protocols : {
          key         = protocol_key
          type        = "ingress"
          from_port   = protocol.port
          to_port     = protocol.port
          protocol    = "tcp"
          description = format(var.security_group_rule_description, protocol.name)
        } if protocol.enabled
      ]
    }
  ]

  context = module.this.context
}

resource "aws_msk_configuration" "config" {
  count = local.enabled ? 1 : 0

  kafka_versions = [var.kafka_version]
  name           = join("-", [module.this.id, replace(var.kafka_version, ".", "-")])
  description    = "Configuration for Amazon Managed Streaming for Kafka"

  server_properties = join("\n", [for k in keys(var.properties) : format("%s = %s", k, var.properties[k])])

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_msk_cluster" "default" {
  #bridgecrew:skip=BC_AWS_LOGGING_18:Skipping `Amazon MSK cluster logging is not enabled` check since it can be enabled with cloudwatch_logs_enabled = true
  #bridgecrew:skip=BC_AWS_LOGGING_18:Skipping `Amazon MSK cluster logging is not enabled` check since it can be enabled with cloudwatch_logs_enabled = true
  #bridgecrew:skip=BC_AWS_GENERAL_32:Skipping `MSK cluster encryption at rest and in transit is not enabled` check since it can be enabled with encryption_in_cluster = true
  count = local.enabled ? 1 : 0

  cluster_name           = module.this.id
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_per_zone * length(var.subnet_ids)
  enhanced_monitoring    = var.enhanced_monitoring

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    client_subnets  = var.subnet_ids
    security_groups = var.create_security_group ? concat(var.associated_security_group_ids, [module.security_group.id]) : var.associated_security_group_ids

    storage_info {
      ebs_storage_info {
        volume_size = var.broker_volume_size
      }
    }

    connectivity_info {
      public_access {
        type = var.public_access_enabled ? "SERVICE_PROVIDED_EIPS" : "DISABLED"
      }
      
    vpc_connectivity {
      client_authentication {
        sasl {
            iam = var.multi_vpc_connectivity_enabled && var.multi_vpc_connectivity_iam_enabled
          }
        }
      }
    }

    
  }

  configuration_info {
    arn      = aws_msk_configuration.config[0].arn
    revision = aws_msk_configuration.config[0].latest_revision
  }

  encryption_info {
    encryption_in_transit {
      client_broker = var.client_broker
      in_cluster    = var.encryption_in_cluster
    }
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn
  }

  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster.html#client_authentication
  client_authentication {
    # Unauthenticated cannot be set to `false` without enabling any authentication mechanisms
    unauthenticated = var.client_allow_unauthenticated

    dynamic "tls" {
      for_each = var.client_tls_auth_enabled ? [1] : []
      content {
        certificate_authority_arns = var.certificate_authority_arns
      }
    }

    sasl {
      scram = var.client_sasl_scram_enabled
      iam   = var.client_sasl_iam_enabled
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.jmx_exporter_enabled
      }
      node_exporter {
        enabled_in_broker = var.node_exporter_enabled
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.cloudwatch_logs_enabled
        log_group = var.cloudwatch_logs_log_group
      }
      firehose {
        enabled         = var.firehose_logs_enabled
        delivery_stream = var.firehose_delivery_stream
      }
      s3 {
        enabled = var.s3_logs_enabled
        bucket  = var.s3_logs_bucket
        prefix  = var.s3_logs_prefix
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to ebs_volume_size in favor of autoscaling policy
      broker_node_group_info[0].storage_info[0].ebs_storage_info[0].volume_size,
    ]
  }

  tags = module.this.tags
}

resource "aws_msk_scram_secret_association" "default" {
  count = local.enabled && var.client_sasl_scram_enabled && var.client_sasl_scram_secret_association_enabled ? 1 : 0

  cluster_arn     = aws_msk_cluster.default[0].arn
  secret_arn_list = var.client_sasl_scram_secret_association_arns
}

module "hostname" {
  count = local.enabled && var.zone_id != null && var.zone_id != "" ? var.broker_dns_records_count : 0

  source  = "cloudposse/route53-cluster-hostname/aws"
  version = "0.13.0"

  zone_id  = var.zone_id
  dns_name = var.custom_broker_dns_name == null ? "${module.this.name}-broker-${count.index + 1}" : replace(var.custom_broker_dns_name, "%%ID%%", count.index + 1)
  records  = local.enabled ? [local.broker_endpoints[count.index]] : []

  context = module.this.context
}

resource "aws_appautoscaling_target" "default" {
  count = local.enabled && var.autoscaling_enabled ? 1 : 0

  max_capacity       = local.broker_volume_size_max
  min_capacity       = 1
  resource_id        = aws_msk_cluster.default[0].arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "default" {
  count = local.enabled && var.autoscaling_enabled ? 1 : 0

  name               = "${aws_msk_cluster.default[0].cluster_name}-broker-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.default[0].arn
  scalable_dimension = one(aws_appautoscaling_target.default[*].scalable_dimension)
  service_namespace  = one(aws_appautoscaling_target.default[*].service_namespace)

  target_tracking_scaling_policy_configuration {
    disable_scale_in = var.storage_autoscaling_disable_scale_in

    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.storage_autoscaling_target_value
  }
}

