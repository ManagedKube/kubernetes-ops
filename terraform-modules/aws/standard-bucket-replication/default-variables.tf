variable "acl" {
  description = "bucket acl"
  type        = string
  default     = "private"
}

variable "tags" {
  description = "override bucket tags"
  type        = map(string)
  default     = {}
}

variable "policy" {
  description = "The bucket policy"
  default     = null
}

variable "attach_policy" {
  default = false
}

variable "versioning" {
  description = "Set to true to enable s3 bucket versioning"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "The SSE encryption algorithm to use"
  type        = string
  default     = "AES256"
}

variable "lifecycle_rules" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}

variable "cors_rule" {
  description = "List of maps containing rules for Cross-Origin Resource Sharing."
  type        = any
  default     = []
}


variable "block_public_acls" {
  type        = bool
  description = "block public ACLs for this bucket"
  default     = false
}

variable "block_public_policy" {
  type        = bool
  description = "block public bucket policies for this bucket"
  default     = false
}

variable "ignore_public_acls" {
  type        = bool
  description = "should ignore public ACLs for this bucket"
  default     = false
}

variable "restrict_public_buckets" {
  type        = bool
  description = "restrict public bucket policies for this bucket"
  default     = false
}

variable "enable_replication" {
  type        = number
  description = "Flag to enable S3 bucket replication | 0=off, 1=on"
  default     = 0
}

variable "replica_region" {
  type        = string
  description = "The AWS region for the replica bucket"
  default     = "us-west-2"
}

variable "replica_bucket_name" {
  description = "name of the replica S3 Bucket"
  type        = string
  default     = ""
}

variable "policy_replica" {
  description = "The replica's bucket policy"
  default     = null
}

variable "replica_provider_profile" {
  description = "The AWS profile to use for the replica aws provider"
  default     = null
}
