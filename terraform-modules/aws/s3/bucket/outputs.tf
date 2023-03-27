output "bucket_id" {
  description = "The ID of the bucket"
  value       = aws_s3_bucket.bucket.id
}

output "bucket_domain_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}