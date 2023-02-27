module "principal_association" {
  source = "../principal_association"

  providers = {
    aws = aws.owner
  }

  principal          = data.aws_caller_identity.this.account_id
  resource_share_arn = var.resource_share_arn
}

module "accepter" {
  source = "../share_accepter"

  resource_share_arn = module.principal_association.principal_association.resource_share_arn
}

data "aws_caller_identity" "this" {}
