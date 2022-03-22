variable "upload_directory" {
  type        = string
  default     = "./yaml"
  description = "The directory with all of the kubernete's yaml files to apply."
}

variable "upload_source_path" {
  type        = string
  default     = "path.module"
  description = "description"
}
