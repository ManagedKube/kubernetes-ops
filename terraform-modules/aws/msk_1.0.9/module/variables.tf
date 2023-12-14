variable "kafka_version" {
  type        = string
  description = <<-EOT
  The desired Kafka software version.
  Refer to https://docs.aws.amazon.com/msk/latest/developerguide/supported-kafka-versions.html for more details
  EOT
}

variable "broker_instance_type" {
  type        = string
  description = "The instance type to use for the Kafka brokers"
}

variable "broker_per_zone" {
  type        = number
  default     = 1
  description = "Number of Kafka brokers per zone"
  validation {
    condition     = var.broker_per_zone > 0
    error_message = "The broker_per_zone value must be at least 1."
  }
}

variable "broker_volume_size" {
  type        = number
  default     = 1000
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for Client Broker"
  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "The subnet_ids list must have at least 1 value."
  }
}

variable "zone_id" {
  type        = string
  description = "Route53 DNS Zone ID for MSK broker hostnames"
  default     = null
}

variable "broker_dns_records_count" {
  type        = number
  description = <<-EOT
  This variable specifies how many DNS records to create for the broker endpoints in the DNS zone provided in the `zone_id` variable.
  This corresponds to the total number of broker endpoints created by the module.
  Calculate this number by multiplying the `broker_per_zone` variable by the subnet count.
  This variable is necessary to prevent the Terraform error:
  The "count" value depends on resource attributes that cannot be determined until apply, so Terraform cannot predict how many instances will be created.
  EOT
  default     = 0
}

variable "custom_broker_dns_name" {
  type        = string
  description = "Custom Route53 DNS hostname for MSK brokers. Use `%%ID%%` key to specify brokers index in the hostname. Example: `kafka-broker%%ID%%.example.com`"
  default     = null
}

variable "client_broker" {
  type        = string
  default     = "TLS"
  description = "Encryption setting for data in transit between clients and brokers. Valid values: `TLS`, `TLS_PLAINTEXT`, and `PLAINTEXT`"
}

variable "encryption_in_cluster" {
  type        = bool
  default     = true
  description = "Whether data communication among broker nodes is encrypted"
}

variable "encryption_at_rest_kms_key_arn" {
  type        = string
  default     = ""
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest"
}

variable "enhanced_monitoring" {
  type        = string
  default     = "DEFAULT"
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. Valid values: `DEFAULT`, `PER_BROKER`, and `PER_TOPIC_PER_BROKER`"
}

variable "certificate_authority_arns" {
  type        = list(string)
  default     = []
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication"
}

variable "client_allow_unauthenticated" {
  type        = bool
  default     = false
  description = "Enable unauthenticated access"
}

variable "client_sasl_scram_enabled" {
  type        = bool
  default     = false
  description = "Enable SCRAM client authentication via AWS Secrets Manager. Cannot be set to `true` at the same time as `client_tls_auth_enabled`"
}

variable "client_sasl_scram_secret_association_enabled" {
  type        = bool
  default     = true
  description = "Enable the list of AWS Secrets Manager secret ARNs for SCRAM authentication"
}

variable "client_sasl_scram_secret_association_arns" {
  type        = list(string)
  default     = []
  description = "List of AWS Secrets Manager secret ARNs for SCRAM authentication"
}

variable "client_sasl_iam_enabled" {
  type        = bool
  default     = false
  description = "Enable client authentication via IAM policies. Cannot be set to `true` at the same time as `client_tls_auth_enabled`"
}

variable "client_tls_auth_enabled" {
  type        = bool
  default     = false
  description = "Set `true` to enable the Client TLS Authentication"
}

variable "jmx_exporter_enabled" {
  type        = bool
  default     = false
  description = "Set `true` to enable the JMX Exporter"
}

variable "node_exporter_enabled" {
  type        = bool
  default     = false
  description = "Set `true` to enable the Node Exporter"
}

variable "cloudwatch_logs_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs"
}

variable "cloudwatch_logs_log_group" {
  type        = string
  default     = null
  description = "Name of the Cloudwatch Log Group to deliver logs to"
}

variable "firehose_logs_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose"
}

variable "firehose_delivery_stream" {
  type        = string
  default     = ""
  description = "Name of the Kinesis Data Firehose delivery stream to deliver logs to"
}

variable "s3_logs_enabled" {
  type        = bool
  default     = false
  description = " Indicates whether you want to enable or disable streaming broker logs to S3"
}

variable "s3_logs_bucket" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket to deliver logs to"
}

variable "s3_logs_prefix" {
  type        = string
  default     = ""
  description = "Prefix to append to the S3 folder name logs are delivered to"
}

variable "properties" {
  type        = map(string)
  default     = {}
  description = "Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html)"
}

variable "autoscaling_enabled" {
  type        = bool
  default     = true
  description = "To automatically expand your cluster's storage in response to increased usage, you can enable this. [More info](https://docs.aws.amazon.com/msk/latest/developerguide/msk-autoexpand.html)"
}

variable "storage_autoscaling_target_value" {
  type        = number
  default     = 60
  description = "Percentage of storage used to trigger autoscaled storage increase"
}

variable "storage_autoscaling_max_capacity" {
  type        = number
  default     = null
  description = "Maximum size the autoscaling policy can scale storage. Defaults to `broker_volume_size`"
}

variable "storage_autoscaling_disable_scale_in" {
  type        = bool
  default     = false
  description = "If the value is true, scale in is disabled and the target tracking policy won't remove capacity from the scalable resource"
}

variable "security_group_rule_description" {
  type        = string
  default     = "Allow inbound %s traffic"
  description = "The description to place on each security group rule. The %s will be replaced with the protocol name"
}

variable "public_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public access to MSK cluster (given that all of the requirements are met)"
}

variable "multi_vpc_connectivity_enabled" {
  type        = bool
  default     = false
  description = "Turn on the vpc connectivitiy"
}

variable "multi_vpc_connectivity_iam_enabled" {
  type        = bool
  default     = false
  description = "Turn on the vpc connectivitiy in IAM mode"
}


variable "cluster_policy_enabled" {
  type        = bool
  default     = false
  description = "Turn on the MSK Cluster Policy to Authorize clients"
}

variable "cluster_policy" {
  type        = string
  default     = ""
  description = "Json Policy to MSK Cluster Policy"
}