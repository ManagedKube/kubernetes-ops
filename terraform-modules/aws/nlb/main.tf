locals {
   health_check_port     = coalesce(var.health_check_port, "traffic-port")
   health_check_protocol = coalesce(var.health_check_protocol, local.target_group_protocol)
   target_group_protocol = "TCP"
   unhealthy_threshold   = coalesce(var.health_check_unhealthy_threshold, var.health_check_threshold)
}

resource "aws_lb" "nlb" {
  name               = var.nlb_name
  internal           = var.enable_internal
  load_balancer_type = "network"
  subnets            = var.nlb_subnets

  enable_deletion_protection = var.enable_deletion_protection

  dynamic "access_logs" {
    # The contents of the list is irrelevant. The only important thing is whether or not to create this block.
    for_each = var.enable_nlb_access_logs
    content {
      bucket  = access_logs.value["bucket_name"]
      prefix  = access_logs.value["bucket_prefix"]
      enabled = true
    }
  }


  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  enable_http2 = var.enable_http2

  tags = var.nlb_tags
}

resource "aws_lb_target_group" "default" {
  count                = var.nlb_target_ips ? 1 : 0
  deregistration_delay = var.deregistration_delay
  name                 = var.target_group_name 
  port                 = var.target_group_port
  protocol             = "TCP"
  proxy_protocol_v2    = var.target_group_proxy_protocol_v2
  slow_start           = var.slow_start
  target_type          = var.target_group_target_type
  vpc_id               = var.vpc_id

  health_check {
    enabled             = var.health_check_enabled
    port                = local.health_check_port
    protocol            = local.health_check_protocol
    path                = local.health_check_protocol == "HTTP" ? var.health_check_path : null
    healthy_threshold   = var.health_check_threshold
    unhealthy_threshold = local.unhealthy_threshold
    interval            = var.health_check_interval
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.nlb_tags

  depends_on = [
    aws_lb.nlb,
  ]
}

###################################################
# Attachment for NLB IP Target Group
###################################################

resource "aws_lb_target_group_attachment" "this" {
  count             = var.nlb_target_ips ? length(var.target_ips) : 0
  target_group_arn  = aws_lb_target_group.default[0].arn
  target_id        = var.nlb_target_ips ? element([for ip in var.target_ips : ip.ip_address], count.index) : ""
  port             = var.nlb_target_ips ? element([for ip in var.target_ips : ip.port], count.index) : 0
}


resource "aws_lb_target_group_attachment" "example" {
  count            = var.nlb_target_ips ? length(var.target_ips) : 0
  target_group_arn = aws_lb_target_group.default[0].arn
  target_id        = var.nlb_target_ips ? element([for ip in var.target_ips : ip.ip_address], count.index) : ""
  port             = var.nlb_target_ips ? element([for ip in var.target_ips : ip.port], count.index) : 0
}


resource "aws_lb_listener" "default" {  
  count                = var.nlb_target_ips ? 1 : 0
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.listener_port
  protocol          = "TCP"

  default_action {
    target_group_arn = var.nlb_target_ips ? aws_lb_target_group.default[0].arn : ""
    type             = "forward"
  }
}
