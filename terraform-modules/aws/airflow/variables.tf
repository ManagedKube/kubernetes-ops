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

variable "environment_class" {
  type        = string
  default     = "mw1.small"
  description = "(Optional) Environment class for the cluster. Possible options are mw1.small, mw1.medium, mw1.large. Will be set by default to mw1.small. Please check the AWS Pricing for more information about the environment classes."
}

variable "max_workers" {
  type        = number
  default     = 10
  description = "(Optional) The maximum number of workers that can be automatically scaled up. Value need to be between 1 and 25. Will be 10 by default."
}

variable "min_workers" {
  type        = number
  default     = 1
  description = "(Optional) The minimum number of workers that you want to run in your environment. Will be 1 by default."
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