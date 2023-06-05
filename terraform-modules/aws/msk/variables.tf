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

# Supported versions: https://docs.aws.amazon.com/msk/latest/developerguide/supported-kafka-versions.html
variable "kafka_version" {
  type        = string
  default     = "2.8.1"
  description = "The desired Kafka software version"
}

variable "broker_per_zone" {
  type        = number
  default     = 1
  description = "Number of Kafka brokers per zone."
}

# https://docs.aws.amazon.com/msk/latest/developerguide/msk-create-cluster.html#broker-instance-types
variable "broker_instance_type" {
  type        = string
  default     = "kafka.t3.small"
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
  default     = null
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest.  If null the key created in this module will be used."
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

variable "s3_bucket_create" {
  type        = bool
  default     = false
  description = "Set it to true if you want the process to create the S3 bucket for you, and false if you already have one."
}

variable "s3_logs_bucket" {
  type        = string
  description = "Name of the S3 bucket to deliver logs to (only able if (s3_bucket_create = true), It is going to create a new resource by you"
}

variable "s3_logs_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable streaming broker logs to S3"
}

variable "s3_logs_prefix" {
  type        = string
  default     = ""
  description = "Prefix to append to the S3 folder name logs are delivered to"
}

variable "security_groups" {
  type        = list(string)
  description = "The security_group_id_list output from the security_groups module"
}

variable "client_tls_auth_enabled" {
  type        = bool
  description = "Set true to enable the Client TLS Authentication"
}

variable "client_sasl_iam_enabled" {
  type        = bool
  default     = false
  description = "Enables client authentication via IAM policies (cannot be set to true at the same time as client_sasl_*_enabled)."
}

variable "common_name" {
 type        = string
 description = "The common name for the CA"
 default     = "example.com"
}

variable "expiration_in_days" {
 type        = number
 description = "The CA expiration in days"
 default     = 7
}
  
variable "key_algorithm" {
 type        = string
 description = "The CA key algorithm"
 default     = "RSA_4096"
}

variable "signing_algorithm" {
 type        = string
 description = "The CA signing algorithm"
 default     = "SHA512WITHRSA"
}

variable "node_exporter_enabled" {
  type        = bool
  default     = false
  description = "Set true to enable the Prometheus Node Exporter"
}

variable "jmx_exporter_enabled" {
  type        = bool
  default     = false
  description = "Set true to enable the Prometheus JMX Exporter"
}

variable "client_sasl_scram_enabled" {
  type        = bool
  default     = false
  description = "Enables SCRAM client authentication via AWS Secrets Manager (cannot be set to `true` at the same time as `client_tls_auth_enabled`)."
}

variable "client_sasl_scram_secret_association_arns" {
  type        = list(string)
  default     = []
  description = "List of AWS Secrets Manager secret ARNs for scram authentication (cannot be set to `true` at the same time as `client_tls_auth_enabled`)."
}

variable "years_valid" {
  type        = number
  default     = 10
  description = "The Certificate will be valid for a period of x years from the time it is issued."
}

variable "create_private_ca" {
  description = "Boolean flag to control if the resources about CA Private should be created"
  type        = bool
  default     = false
}