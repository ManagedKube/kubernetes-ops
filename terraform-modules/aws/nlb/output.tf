# Output the DNS name of the external Application Load Balancer (in the `aws_lb` resource).
output "load_balancer_external_dns" {
  value       = aws_lb.nlb.dns_name
  description = "DNS name for the Network Load Balancer"
}