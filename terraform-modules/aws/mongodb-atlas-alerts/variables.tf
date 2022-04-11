variable "mongodbatlas_projectid" {
  type        = string
  description = "The unique ID for the project to create the database user."
}

variable "default_alerts" {
  type        = list(any)
  default     = [
    {
      event_type = "OUTSIDE_METRIC_THRESHOLD"
      enabled = true
    },
  ]
  description = "description"
}

variable "user_alerts" {
  type        = string
  default     = ""
  description = "description"
}

