output "nlb_arn" {
  value = aws_lb.nlb.arn
  description = "The ARN of the load balancer (matches id)."
}

output "nlb_dns_name" {
  value = aws_lb.nlb.dns_name
  description = "The DNS name of the load balancer."
}