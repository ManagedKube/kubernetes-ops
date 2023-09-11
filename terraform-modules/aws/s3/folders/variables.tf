variable "bucket_name" {
  description = "The name of the S3 bucket"
}

variable "folder_structure" {
  type = list(string)
  description = <<-EOT
    The folder structure to create in S3. 
    Example usage:
    [
        "folder1",
        "folder2",
        "folder3",
        "folder4/subfolder1/subfolder2"
    ]
  EOT
}