variable "tags" {
  type = map(string)

  default = {
    Name        = "dev"
    Environment = "env"
    Account     = "dev"
    Group       = "devops"
    Region      = "us-east-1"
    managed_by  = "Terraform"
  }
}

variable "aws_region" {}

variable "amazon_side_asn" {
  default = "64512"
}

variable "auto_accept_shared_attachments" {
  default = "disable"
}

variable "description" {
  default = "Transit gateway created via Terraform"
}

variable "dns_support" {
  default = "enable"
}

variable "vpn_ecmp_support" {
  default = "enable"
}
