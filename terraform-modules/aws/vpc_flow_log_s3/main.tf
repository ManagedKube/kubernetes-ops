resource "aws_flow_log" {
  log_destination      = var.vpc_flow_log_destination
  log_destination_type = var.vpc_flow_log_destination_type
  traffic_type         = var.vpc_flow_traffic_type
  vpc_id               = var.vpc_id
  tags                 = var.tags
}
