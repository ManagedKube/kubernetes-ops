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

variable "airflow_version" {
  type        = string
  default     = null
  description = "(Optional) Airflow version of your environment, will be set by default to the latest version that MWAA supports."
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

variable "webserver_access_mode" {
  description = "(Optional) Specifies whether the webserver should be accessible over the internet or via your specified VPC. Possible options: PRIVATE_ONLY (default) and PUBLIC_ONLY"
  type        = string
  default     = "PRIVATE_ONLY"

  validation {
    condition     = contains(["PRIVATE_ONLY", "PUBLIC_ONLY"], var.webserver_access_mode)
    error_message = "Invalid input, options: \"PRIVATE_ONLY\", \"PUBLIC_ONLY\"."
  }
}

variable "iam_extra_policies" {
  description = "List of additional policies to create and attach to the IAM role"
  type        = list(object({
    name_prefix = string
    policy_json = string
  }))
  default     = []
}

variable "sg_extra_ids" {
  description = "List of additional sg to create and attach to Airflow"
  type        = list(string)
  default     = []
}

variable "requirements_s3_path" {
  description = "The S3 path for the MWAA requirements file."
  type        = string
  default     = ""
}

#You can looking for variables in the following link:
#https://docs.aws.amazon.com/mwaa/latest/userguide/configuring-env-variables.html
variable "airflow_configuration_options" {
  description = "The Airflow override options"
  type        = any
  default     = null
}