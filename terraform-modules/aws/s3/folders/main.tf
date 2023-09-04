data "aws_s3_bucket" "existing_bucket" {
  bucket = var.bucket_name
}

# Recursive function to create folders
locals {
  recursive_create_folders = flatten(local.create_folders(var.folder_structure))
}

# Function to create folders recursively
locals {
  create_folders = function(folders) {
    return [
      for folder in folders :
      concat(
        [
          {
            key          = folder.key
            source       = "/dev/null"  # Use an empty file as the source
            content_type = "application/octet-stream"
          },
        ],
        local.create_folders(folder.subfolders)
      )
    ]
  }
}

# Create folders using aws_s3_bucket_object
resource "aws_s3_bucket_object" "folder_structure" {
  for_each = {
    for folder in local.recursive_create_folders :
    folder.key => {
      key          = folder.key
      source       = folder.source
      content_type = folder.content_type
    }
  }

  bucket = data.aws_s3_bucket.existing_bucket.id
  key    = each.value.key
  source = each.value.source
  content_type = each.value.content_type
}