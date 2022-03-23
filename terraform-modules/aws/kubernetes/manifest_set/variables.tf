variable "upload_directory" {
  type        = string
  default     = "yaml"
  description = "Just the directory name containing the folder to recursively apply from."
}

variable "upload_source_path" {
  type        = string
  default     = "path.cwd"
  description = "The full path to where the directory var.upload_directory resides (not including the var.upload_directory dir name)."
}
