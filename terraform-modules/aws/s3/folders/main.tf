resource "aws_s3_object" "directory_structure" {
  for_each = var.folder_structure
  bucket       = var.bucket_name
  key          = "${each.value}/"
  content_type = "application/x-directory"
}