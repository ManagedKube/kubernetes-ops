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
variable "force_destroy" {
  type        = bool
  default     = false
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
}
#Buckets input vars

variable "versioning_enabled" {
  type        = bool
  description = "A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket"
  default     = false
}

variable "access_log_bucket_name" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket where s3 access log will be sent to"
}

variable "allow_ssl_requests_only" {
  type        = bool
  default     = true
  description = "Set to `true` to require requests to use Secure Socket Layer (HTTPS/SSL). This will explicitly deny access to HTTP requests"
}

variable "s3_object_ownership" {
  type        = string
  default     = "BucketOwnerPreferred"
  description = "Specifies the S3 object ownership control. Valid values are `ObjectWriter`, `BucketOwnerPreferred`, and 'BucketOwnerEnforced'."
}

variable "acl" {
  type        = string
  description = "The canned ACL to apply. We recommend log-delivery-write for compatibility with AWS services"
  default     = "log-delivery-write"
}

variable "is_multi_region_trail" {
  type        = bool
  default     = true
  description = "Specifies whether the trail is created in the current region or in all regions"
}

variable "restrict_public_buckets" {
  type        = bool
  default     = true
  description = "Set to `false` to disable the restricting of making the bucket public"
}


#KMS Variables
variable "kms_cloudwatch_loggroup_enable" {
  type        = bool
  default     = true
  description = "It will create for you a standard kms for cloudwatch that will free it from possible vulnerabilities. (cloudwatch-loggroup)"
}

variable "kms_cloudtrail_enable" {
  type        = bool
  default     = true
  description = "It will create for you a standard kms for cloudwatch that will free it from possible vulnerabilities.. (cloudwatch-loggroup)"
}

variable "kms_cloudwatch_loggroup_deletion_window_in_days" {
  type        = number
  default     = 30
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. (cloudwatch-loggroup)"
}

variable "kms_cloudwatch_loggroup_kms_enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled. Defaults to false. (cloudwatch-loggroup)"
}

variable "kms_cloudtrail_deletion_window_in_days" {
  type        = number
  default     = 30
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. (cloudtrail-trails)"
}

variable "kms_cloudtrail_kms_enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled. Defaults to false. (cloudtrail-trails)"
}