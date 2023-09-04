variable "bucket_name" {
  description = "The name of the S3 bucket"
}

variable "folder_structure" {
  description = "The folder structure to create in S3 (list of objects)"
  type        = list(object({
    key       = string
    subfolders = list(object({
      key = string
    }))
  }))
}