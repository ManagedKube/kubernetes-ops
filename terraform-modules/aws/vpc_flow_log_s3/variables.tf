variable "vpc_flow_log_name" {
  default = "vpc_flow_log"
  description = "The name of the flow_log"
}

variable "vpc_flow_log_destination_type" {
  default = "s3"
  description = "The type of the logging destination. Valid values: cloud-watch-logs, s3"
}

variable "vpc_flow_log_destination" {
  description = "(Required) The ARN of the logging destination."
}

variable "vpc_flow_traffic_type" {
  default = "ALL"
  description = "(Required) The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL."
}

variable "vpc_id" {
  default = "ALL"
  description = "(Required) VPC ID to attach to"
}

variable "tags" {
  type = map(any)
}