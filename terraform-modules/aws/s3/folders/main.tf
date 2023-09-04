locals {
  folder_structure_map = { for idx, folder in var.folder_structure : idx => folder }
}

resource "aws_s3_object" "directory_structure" {
  for_each = local.folder_structure_map

  bucket = var.bucket_name
  key    = each.value
  content_type = "application/x-directory"
}