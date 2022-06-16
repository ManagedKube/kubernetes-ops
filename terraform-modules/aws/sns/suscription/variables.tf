variable "protocol" {
  description = "(Required) Protocol to use. Valid values are: sqs, sms, lambda, firehose, and application. Protocols email, email-json, http and https"
}

variable "endpoint" {
  description = "(Required) In email endpoint is an email address."
}

variable "topic_arn" {
    description = "(Required) ARN of the SNS topic to subscribe to."
}