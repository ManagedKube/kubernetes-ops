locals {
  upload_directory = var.use_local_files ? var.local_upload_directory : "${path.module}/file_sets/${var.file_set_to_upload}/"

  # https://docs.aws.amazon.com/systems-manager/latest/userguide/integration-s3-shell.html
  # Step 5 the Source Info json
  source_info = {
    path = "https://s3.amazonaws.com/${var.s3_bucket_name}/${var.s3_bucket_key_path}${var.file_set_to_upload}/"
  }
}

resource "aws_ssm_association" "this" {
  name = "AWS-RunRemoteScript"

  parameters = {
    sourceType = "S3"
    sourceInfo = "${jsonencode(local.source_info)}"
    commandLine = var.run_command
    workingDirectory = "${var.upload_working_dir}/${var.s3_bucket_key_path}${var.file_set_to_upload}"
    executionTimeout = var.execution_time
  }

  targets {
    key    = "tag:${var.target_ec2_tag_key}"
    values = var.target_ec2_tag_values
  }

  depends_on = [
    aws_s3_bucket_object.files,
  ]
}

# Updloads all the files/folders based on the var.file_set_to_upload
resource "aws_s3_bucket_object" "files" {
  for_each      = fileset(local.upload_directory, "**/*.*")
  bucket        = var.s3_bucket_name
  key           = "${var.s3_bucket_key_path}${var.file_set_to_upload}/${replace(each.value, local.upload_directory, "")}"
  content        = templatefile("${local.upload_directory}${each.value}", {
    #############################################
    # All template vars for the various file_sets
    #############################################
    # Datadog file_sets var
    prometheus_url = var.datadog_template_vars.prometheus_url
    namespace      = var.datadog_template_vars.namespace
  })
  acl           = "private"
  source_hash   = filemd5("${local.upload_directory}${each.value}")
  server_side_encryption = "AES256"
}
