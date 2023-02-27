resource "aws_ram_resource_share_accepter" "this" {
  share_arn = var.resource_share_arn
}
