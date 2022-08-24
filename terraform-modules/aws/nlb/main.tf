resource "aws_lb" "nlb" {
  name               = var.nlb_name
  internal           = var.enable_internal 
  load_balancer_type = "network"
  subnets            = var.nlb_subnets

  enable_deletion_protection = var.enable_deletion_protection

  dynamic "access_logs" {
    # The contents of the list is irrelevant. The only important thing is whether or not to create this block.
    for_each = var.enable_alb_access_logs ? ["use_access_logs"] : []
    content {
      bucket  = var.nlb_access_logs_s3_bucket_name
      prefix  = var.nlb_access_logs_s3_prefix
      enabled = true
    }
  }


 enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

 enable_http2 = var.enable_http2

  tags = {
    Environment = "Ops"
  }
}