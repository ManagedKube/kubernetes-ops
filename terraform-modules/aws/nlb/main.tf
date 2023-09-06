resource "aws_lb" "nlb" {
  name               = var.nlb_name
  internal           = var.enable_internal
  load_balancer_type = "network"
  subnets            = var.nlb_subnets
  security_groups    = var.nlb_security_groups
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

# Define an AWS target group resource for the ALB
resource "aws_lb_target_group" "tg" {
  name     = var.target_group_name
  port     = var.target_group_port              
  protocol = var.target_group_protocol
  vpc_id   = var.target_vpc_id
  target_type = "ip"
}

# Attach instance 1 to the target group
#resource "aws_lb_target_group_attachment" "tg-attachment-1" {
#  target_group_arn = aws_lb_target_group.tg.arn
#  target_id        = var.tg_attachment_ip_1
#  port             = var.tg_attachment_port_1
#}

# Attach instance 2 to the target group
#resource "aws_lb_target_group_attachment" "tg-attachment-2" {
#  target_group_arn = aws_lb_target_group.tg.arn
#  target_id        = var.tg_attachment_ip_2
#  port             = var.tg_attachment_port_2
#}

# Attach instance 3 to the target group
#resource "aws_lb_target_group_attachment" "tg-attachment-3" {
#  target_group_arn = aws_lb_target_group.tg.arn
#  target_id        = var.tg_attachment_ip_3
#  port             = var.tg_attachment_port_3
#}

# Attach instances to the target group dynamically based on the variable
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count = length(var.target_attachments)

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.target_attachments[count.index].target_id
  port             = var.target_attachments[count.index].port
}

# Define a listener for the ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  # Define the default action for the listener (forward traffic to the target group)
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}