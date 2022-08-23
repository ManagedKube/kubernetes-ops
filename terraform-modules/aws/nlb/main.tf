resource "aws_lb" "nlb" {
  name               = var.nlb_name
  internal           = var.enable_internal 
  load_balancer_type = "network"
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Environment = "Ops"
  }
}