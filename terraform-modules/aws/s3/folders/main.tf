resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}

# Recursive function to create folders
locals {
  recursive_create_folders = flatten([
    for folder in var.folder_structure :
    [
      module.create_folder[folder.key].path,
      local.create_subfolders(folder.subfolders, folder.key)
    ]
  ])
}

# Function to create subfolders recursively
locals {
  create_subfolders = function(subfolders, parent_folder_key) {
    return [
      for subfolder in subfolders :
      [
        module.create_folder["${parent_folder_key}/${subfolder.key}"].path,
        local.create_subfolders(subfolder.subfolders, "${parent_folder_key}/${subfolder.key}")
      ]
    ]
  }
}