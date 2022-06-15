variable "region" {
  type = string
}

variable "metrics_paths" {
  type        = list(string)
  description = "List of paths to CloudWatch metrics configurations"
}