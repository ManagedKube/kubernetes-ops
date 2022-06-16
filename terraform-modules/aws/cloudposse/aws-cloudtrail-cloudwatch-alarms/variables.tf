variable "region" {
  type = string
}

variable "metrics_paths" {
  type        = list(string)
  description = "List of paths to CloudWatch metrics configurations"
}

variable "cloudtrail_event_selector" {
  type = list(object({include_management_events = bool, read_write_type = string, data_resource = list(object({type = string, values = list(string)}))}))
  
  description = "This enables the cloudtrail even selector to track all S3 API calls by default: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail."
  default = [
    {
      include_management_events = true
      read_write_type = "All"
      data_resource = [{
        type = "AWS::S3::Object"
        values = ["arn:aws:s3"]
      }]
    }
  ]
}


