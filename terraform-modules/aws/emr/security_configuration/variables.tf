variable "name" {
  type        = string
  default     = "security_config"
  description = "The name of the security configuration"
}

variable "configuration" {
  type        = string
  default     = <<EOF
{
  "EncryptionConfiguration": {
    "AtRestEncryptionConfiguration": {
      "S3EncryptionConfiguration": {
        "EncryptionMode": "SSE-S3"
      }
    },
    "EnableInTransitEncryption": false,
    "EnableAtRestEncryption": true
  }
}
EOF
  description = "The security configuration json"
}
