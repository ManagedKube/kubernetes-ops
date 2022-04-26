variable "name" {
  description = "The name for the various resources"
  default     = "github_oidc"
}

variable "url" {
  default = "https://token.actions.githubusercontent.com"
}

variable "client_id_list" {
  type    = list(string)
  default = [
    "sts.amazonaws.com"
  ]
}

# This is the thumbprint returned if you were to create an "identity provider" in AWS and gave
# it this url: https://token.actions.githubusercontent.com
variable "thumbprint_list" {
  type    = list(string)
  default = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
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

variable "create_identity_provider" {
  type        = bool
  default     = true
  description = "This switch allows you to create or not create the identity provider.  Only one can exist.  If you are creating multiple Github OIDC Federations, only one of the instantiations should create this or the Terraform run will fail."
}