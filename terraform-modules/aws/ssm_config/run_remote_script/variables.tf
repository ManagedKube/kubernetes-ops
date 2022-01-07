variable "s3_bucket_name" {
  type        = string
  default     = "rpg-featurespace-ssm-run-script-for-unit-testing-purposes"
  description = "The bucket name to hold the SSM script and file items"
}

variable "s3_bucket_key_path" {
  type        = string
  default     = "node_configs/"
  description = "The bucket sub folder to put the items into."
}

variable "target_ec2_tag_key" {
  type        = string
  default     = "node_list_group_name"
  description = "The EC2 instance tag key name to target"
}

variable "target_ec2_tag_values" {
    type = list(string)
    default = ["rpg-featurespace-dev-app-cep", "foo"]
    description = "The EC2 instance tag values to target"
}

variable "upload_working_dir" {
    type = string
    default = "/tmp/ssm-configs"
    description = "The location on the remote server to update the files to"
}

variable "execution_time" {
    type = string
    default = "3600"
    description = "The max execution time for the script"
}

variable "file_set_to_upload" {
    type = string
    default = "datadog"
    description = "The file set directory to upload and run on the remote server(s)"
}

variable "run_command" {
  type        = string
  default     = "run.sh"
  description = "The script to execute."
}

variable "datadog_template_vars" {
  type = map
  description = "Templating: Datadog input variables"
  default = {
    prometheus_url = "http://localhost:9090/api/prometheus/metrics"
    namespace      = "name-to-prepend"
  }
}

variable "use_local_files" {
  type        = bool
  description = "Flag to upload files from your local path or files from this module in the file_sets.  If this is set to true, the input local_upload_directory is required."
  default     = false
}

variable "local_upload_directory" {
  type        = string
  description = "The local file path to upload.  Example, if uploading a directory named `file` from the same location where you are instantiation this module from.  The input var should be: `./files/`"
  default     = null
}
