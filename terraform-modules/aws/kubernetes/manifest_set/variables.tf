variable "upload_directory" {
  type        = string
  default     = "yaml"
  description = "Just the directory name containing the folder to recursively apply from."
}

variable "fileset_pattern" {
  type        = string
  default     = "**/*.*"
  description = "The fileset() pattern match string.  Useful if you have other files that are not yaml files that you dont want to add in to be applied to the kube manifest."
}


variable "upload_source_path" {
  type        = string
  default     = "path.cwd"
  description = "The full path to where the directory var.upload_directory resides (not including the var.upload_directory dir name)."
}

variable "template_vars" {
  type        = map
  default     = {}
  description = "The map for the templatefile() function to run the yamls through"
}


