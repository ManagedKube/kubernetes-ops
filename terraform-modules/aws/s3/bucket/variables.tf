variable "aws_region" {
  default = "us-east-1"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to assign to the bucket. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  default     = {}
}

variable "bucket" {
  type        = string
  description = "The name of the bucket. If omitted, Terraform will assign a random, unique name. Must be less than or equal to 63 characters in length."
}

variable "block_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should block public ACLs for this bucket."
}

variable "block_public_policy" {
  type        = bool
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
}

variable "ignore_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
}

variable "policy" {
  type        = string
  default     = null
}

variable "enable_key_rotation" {
  type        = bool
  description = "(Optional) Specifies whether key rotation is enabled. Defaults to false."
  default     = true
}

variable "deletion_window_in_days" {
  type        = number
  description = "(Optional) The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key."
  default     = 10
}

variable "enable_versioning" {
  type        = bool
  description = "Enable S3 versioning"
  default     = true
}

variable "versioning" {
  type        = string
  description = "(Required) The versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets."
  default     = "Enabled"
}

variable "enable_logging" {
  type        = bool
  description = "Enable S3 logging"
  default     = false
}

variable "logging_bucket_name" {
  type        = string
  description = "(Required) The name of the bucket where you want Amazon S3 to store server access logs.  Could be the same as the bucket name."
  default     = "can-be-the-same-as-the-bucket-name"
}

variable "logging_bucket_prefix" {
  type        = string
  description = "The prefix to add to the logs"
  default     = "s3-log/"
}

variable "enable_bucket_owner_enforced" {
  type        = bool
  description = "BucketOwnerEnforced choice of object ownership, which is used to disable ACL-s."
  #Bucket owner enforced (recommended) – ACLs are disabled, and the bucket
  #owner automatically owns and has full control over every object in the bucket. 
  #ACLs no longer affect permissions to data in the S3 bucket. The bucket uses policies 
  #to define access control.
  #https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html
  default     = true 

}
variable "bucket_ownership_controls_rule" {
  type        = string
  default     = "BucketOwnerEnforced"
  description = "It's compliance rule that helps ensure the ownership of Amazon S3 buckets is set to the correct AWS account or AWS account within the same organization. values (BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced)"
}
