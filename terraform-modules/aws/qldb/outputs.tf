output "id" {
  value       = aws_qldb_ledger.this.id
}

output "arn" {
  value       = aws_qldb_ledger.this.arn
}

output "vpc_endpoint_id" {
  value       = aws_vpc_endpoint.qldb.id
}

