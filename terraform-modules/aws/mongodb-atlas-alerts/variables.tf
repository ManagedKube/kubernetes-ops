variable "mongodbatlas_projectid" {
  type        = string
  description = "The unique ID for the project to create the database user."
}

variable "default_alerts" {
  type        = string
  default     = ""
  description = "description"
}

variable "user_alerts" {
  type        = string
  default     = ""
  description = "description"
}

