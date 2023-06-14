variable "account_tags" {
  description = "Tags for each AWS account"
  type        = map(map(string))
  default     = {}
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}
