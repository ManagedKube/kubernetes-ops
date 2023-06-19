# Create an AWS WAFv2 IP set

resource "aws_wafv2_ip_set" "example" {
  name               = var.ip_set_name
  description        = var.ip_set_description
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.ip_addresses

  tags = var.tags
}
