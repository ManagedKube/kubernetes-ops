output "bucket_id" {
  value = module.terraform-aws-s3-bucket-single-bucket[*].s3_bucket_id
}

output "bucket_arn" {
  value = module.terraform-aws-s3-bucket-single-bucket[*].s3_bucket_arn
}

output "bucket_id_source_replica" {
  value = module.terraform-aws-s3-bucket-source-replica[*].s3_bucket_id
}

output "bucket_arn_source_replica" {
  value = module.terraform-aws-s3-bucket-source-replica[*].s3_bucket_arn
}

output "bucket_id_replica" {
  value = module.terraform-aws-s3-bucket-replica[*].s3_bucket_id
}

output "bucket_arn_replica" {
  value = module.terraform-aws-s3-bucket-replica[*].s3_bucket_arn
}