variable "log_group_name" {
  type        = string
  default     = "log-group-default"
  description = "Log group name of cloud watch"
}

variable "tags" {
  type = map(any)
}