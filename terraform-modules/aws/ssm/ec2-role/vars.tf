variable "tags" {
  type = map(string)

  default = {
    Environment = "env"
    Account     = "dev"
    Group       = "devops"
    Region      = "us-east-1"
    managed_by  = "Terraform"
  }
}

variable "region" {
  description = "AWS region (i.e. us-east-1)"
}

variable "name" {
  description = "The postfix to add to the name"
  default = ""
}

variable "s3_bucket_name" {
  description = "S3 bucket for the SSM interactive session logs"
  default = ""
}

variable "s3_bucket_prefix" {
  description = "S3 bucket prefix for the SSM interactive session logs"
  default = ""
}
