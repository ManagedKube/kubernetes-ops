variable "name" {
  description = "The name of this vpc link"
  type        = string
}

variable "private_link_target_arns" {
  description = "A list of strings of the LB arns to link the API Gateway to"
  type        = list(string)
}

variable "tags" {
  description = "Tags"
  type        = any
}

resource "aws_api_gateway_vpc_link" "this" {
  name        = var.name
  description = "VPC Link"
  target_arns = var.private_link_target_arns
  tags        = var.tags
}

output "id" {
  value = aws_api_gateway_vpc_link.this.id
  description = "Identifier of the VpcLink"
}
