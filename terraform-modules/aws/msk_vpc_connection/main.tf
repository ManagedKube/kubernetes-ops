resource "aws_msk_vpc_connection" "vc" {
  authentication     = "SASL_IAM"
  target_cluster_arn = var.msk_arn
  vpc_id             = var.vpc_id
  client_subnets     = var.subnets
  security_groups    = var.security_groups
}
