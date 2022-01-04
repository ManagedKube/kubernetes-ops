variable "name" {
  description = "The name for the various resources"
  default     = "github_oidc"
}

variable "url" {
  default = "https://token.actions.githubusercontent.com"
}

variable "client_id_list" {
  default = [
    "sts.amazonaws.com"
  ]
}

variable "thumbprint_list" {
  default = [
    "a031c46782e6e6c662c2c87c76da9aa62ccabd8e"
  ]
}

variable "aws_policy_json" {
  description = "The AWS policy in a json format"
  default     = <<-EOT
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "*",
        "Resource": "*"
      }
    ]
}
EOT
}

variable "validate_conditions" {
  description = "Conditions to validate"
  type        = set(string)
  default     = ["repo:octo-org/octo-repo:ref:refs/heads/octo-branch"]
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags"
}
