variable "bucket_name" {
  description = "name of the S3 Bucket"
  type        = string
}

variable "env" {
  description = "environment or aws account name"
  type        = string
}

variable "region" {
  description = "name of the aws region"
  type        = string
}

variable "group" {
  description = "organizational group name"
  type        = string
}
