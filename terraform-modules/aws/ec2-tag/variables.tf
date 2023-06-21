variable "account_tags" {
  description = <<-EOF
    Tags for each AWS account.
    
    This variable allows you to provide tags for different AWS accounts using a map structure. Each AWS account is identified by its unique account ID, and you can specify multiple tags for each account using key-value pairs.

    Example Usage:

    inputs:
      {
        "account_id_1" = {
          "key1" = "value1"
          "key2" = "value2"
          "key3" = "value3"
          "key4" = "value4"
        }
        "account_id_1" = {
          "key1" = "value1"
          "key2" = "value2"
          "key3" = "value3"
          "key4" = "value4"
        }
        ... (Add more AWS account tags here) ...
      }
  EOF
  type        = map(map(string))
  default     = {}
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}
