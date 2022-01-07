variable "aws_region" {
  type        = string
  description = "The AWS region you want to deploy to"
}

variable "vpc_id" {
  type        = string
  description = "The VPC id of where you want to provision MSK"
}

variable "name" {
  type        = string
  description = "Solution name"
}


variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name or abbreviation,"
}

variable "client_broker" {
  type        = string
  description = "Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT"
}

variable "zone_id" {
  type        = string
  description = "Route53 DNS Zone ID for MSK broker hostnames"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for Client Broker"
}

variable "kafka_version" {
  type        = string
  description = "The desired Kafka software version"
}

variable "number_of_broker_nodes" {
  type        = number
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets."
}

variable "broker_instance_type" {
  type        = string
  description = "The instance type to use for the Kafka brokers"
}

variable "broker_volume_size" {
  type        = number
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
}

variable "tags" {
  type        = map(any)
  description = "Additional tags"
}

variable "encryption_in_cluster" {
  type        = bool
  description = "Whether data communication among broker nodes is encrypted"
}

variable "encryption_at_rest_kms_key_arn" {
  type        = string
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest"
}

variable "cloudwatch_logs_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs"
}

variable "cloudwatch_logs_log_group" {
  type        = string
  description = "Name of the Cloudwatch Log Group to deliver logs to"
}

variable "enhanced_monitoring" {
  type        = string
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. Valid values: DEFAULT, PER_BROKER, and PER_TOPIC_PER_BROKER"
}

variable "s3_logs_bucket" {
  type        = string
  description = "Name of the S3 bucket to deliver logs to"
}

variable "s3_logs_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable streaming broker logs to S3"
}

variable "s3_logs_prefix" {
  type        = string
  description = "Prefix to append to the S3 folder name logs are delivered to"
}

variable "node_exporter_enabled" {
  type        = bool
  description = "Set true to enable the Node Exporter"
}

variable "security_groups" {
  type        = list(string)
  description = "The security_group_id_list output from the security_groups module"
}

variable "certificate_authority_arns" {
  type        = list(string)
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication"
}

variable "client_tls_auth_enabled" {
  type        = bool
  description = "Set true to enable the Client TLS Authentication"
}