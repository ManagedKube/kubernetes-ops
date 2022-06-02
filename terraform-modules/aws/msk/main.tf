locals{
  years_valid = 10 
}

resource "aws_cloudwatch_log_group" "msk_cloudwatch_log_group" {
  name = var.cloudwatch_logs_log_group
  tags = var.tags
}

#######################################
# S3 bucket
#######################################
resource "aws_kms_key" "this" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "this" {
  bucket = var.s3_logs_bucket
  tags   = var.tags
}

# resource "aws_s3_bucket_acl" "this" {
#   bucket = aws_s3_bucket.this.id
#   acl    = "private"
# }

# When turning on server side encryption the ACM creation failes with:
# │ Error: error creating ACM PCA Certificate Authority: ValidationException: Permission error with your S3 bucket '476264532441-us-west-2-msk-logs'. Check that your bucket policy, encryption settings, S3 Block Public Access settings, and global account permissions are configured correctly. For more information, check the service documentation.
# │       status code: 400, request id: 3ba26851-f96a-48b6-a9a2-ca7a68be8e5f
# │ 
# │   with aws_acmpca_certificate_authority.this,
# │   on main.tf line 91, in resource "aws_acmpca_certificate_authority" "this":
# │   91: resource "aws_acmpca_certificate_authority" "this" {
# resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
#   bucket = aws_s3_bucket.this.bucket

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.this.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }

data "aws_iam_policy_document" "acmpca_bucket_access" {
  statement {
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    principals {
      identifiers = ["acm-pca.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.acmpca_bucket_access.json
}

#######################################
# Private CA
#######################################
# data "aws_partition" "current" {
# }

# resource "aws_acmpca_certificate_authority_certificate" "cacert" {
#   certificate_authority_arn = aws_acmpca_certificate_authority.this.arn

#   certificate       = aws_acmpca_certificate.cert.certificate
#   certificate_chain = aws_acmpca_certificate.cert.certificate_chain
# }

# resource "aws_acmpca_certificate" "cert" {
#   certificate_authority_arn   = aws_acmpca_certificate_authority.this.arn
#   certificate_signing_request = aws_acmpca_certificate_authority.this.certificate_signing_request
#   signing_algorithm           = "SHA512WITHRSA"

#   template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

#   validity {
#     type  = "YEARS"
#     value = local.years_valid
#   }
# }

# resource "aws_acmpca_certificate_authority" "this" {
#   certificate_authority_configuration {
#     key_algorithm     = var.key_algorithm
#     signing_algorithm = var.signing_algorithm

#     subject {
#       common_name = var.common_name
#     }
#   }
  
#   type = "ROOT"

#   revocation_configuration {
#     crl_configuration {
#       custom_cname       = "crl.${var.common_name}"
#       enabled            = true
#       expiration_in_days = var.expiration_in_days
#       s3_bucket_name     = aws_s3_bucket.this.id
#     }
#   }
  
#   tags   = var.tags

#   depends_on = [aws_s3_bucket_policy.this]
# }

#######################################
# MSK Cluster
#######################################
module "msk" {
  source                         = "cloudposse/msk-apache-kafka-cluster/aws"
  version                        = "v0.8.4"
  namespace                      = var.namespace
  name                           = var.name
  vpc_id                         = var.vpc_id
  client_broker                  = var.client_broker
  zone_id                        = var.zone_id
  security_groups                = var.security_groups
  subnet_ids                     = var.subnet_ids
  kafka_version                  = var.kafka_version
  number_of_broker_nodes         = var.number_of_broker_nodes
  broker_instance_type           = var.broker_instance_type
  broker_volume_size             = var.broker_volume_size
  tags                           = var.tags
  certificate_authority_arns     = [] #[aws_acmpca_certificate_authority.this.arn]
  client_tls_auth_enabled        = var.client_tls_auth_enabled
  client_sasl_iam_enabled        = var.client_sasl_iam_enabled
  encryption_in_cluster          = var.encryption_in_cluster
  encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn != null ? var.encryption_at_rest_kms_key_arn : aws_kms_key.this.arn
  cloudwatch_logs_enabled        = var.cloudwatch_logs_enabled
  cloudwatch_logs_log_group      = var.cloudwatch_logs_enabled == true ? var.cloudwatch_logs_log_group : ""
  enhanced_monitoring            = var.enhanced_monitoring
  node_exporter_enabled          = var.node_exporter_enabled
  jmx_exporter_enabled           = var.jmx_exporter_enabled
  s3_logs_bucket                 = var.s3_logs_enabled == true ? aws_s3_bucket.this.id : ""
  s3_logs_enabled                = var.s3_logs_enabled
  s3_logs_prefix                 = var.s3_logs_enabled == true ? var.s3_logs_prefix : ""

  depends_on = [
    aws_cloudwatch_log_group.msk_cloudwatch_log_group,
    aws_s3_bucket.this,
    aws_acmpca_certificate.cert
  ]
}


