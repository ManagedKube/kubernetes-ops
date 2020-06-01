output "region" {
  value = var.region
}

output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "aws_nat_gateway_id" {
  value = aws_nat_gateway.main.*.id
}