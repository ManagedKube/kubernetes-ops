variable "airflow_name" {
  type        = string
  default     = "airflow"
  description = "Airflow name"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The vpc ID"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "(Required) The private subnet IDs in which the environment should be created. MWAA requires two subnets."
}

variable "source_bucket_arn" {
  type        = string
  default     = "s3://foo"
  description = "The Dag's S3 bucket arn: arn:aws:s3:::bucketname"
}

variable "source_bucket_name" {
  type        = string
  default     = "foo"
  description = "The Dag's S3 bucket name"
}

variable "dag_s3_path" {
  type        = string
  default     = "dags/"
  description = "The dag's S3 path"
}

variable "tags" {
  type        = any
  default     = {}
  description = "A set of tags to place on the items"
}

variable "dag_processing_log_level" {
  type        = string
  default     = "INFO"
  description = "The log level: INFO | WARNING | ERROR | CRITICAL"
}

variable "scheduler_log_level" {
  type        = string
  default     = "INFO"
  description = "The log level: INFO | WARNING | ERROR | CRITICAL"
}

variable "task_log_level" {
  type        = string
  default     = "INFO"
  description = "The log level: INFO | WARNING | ERROR | CRITICAL"
}

variable "webserver_log_level" {
  type        = string
  default     = "INFO"
  description = "The log level: INFO | WARNING | ERROR | CRITICAL"
}

variable "worker_log_level" {
  type        = string
  default     = "INFO"
  description = "The log level: INFO | WARNING | ERROR | CRITICAL"
}