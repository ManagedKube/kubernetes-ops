locals{
  years_valid = var.years_valid 
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
  count  = var.s3_bucket_create ? 1 : 0
  bucket = var.s3_logs_bucket
  tags   = var.tags 
}

data "aws_iam_policy_document" "acmpca_bucket_access" {
  count = var.s3_bucket_create ? 1 : 0
  statement {
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*",
    ]

    principals {
      identifiers = ["acm-pca.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = var.s3_bucket_create ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.acmpca_bucket_access[0].json
}

#######################################
# Private CA
#######################################
data "aws_partition" "current" {
}

resource "aws_acmpca_certificate_authority_certificate" "cacert" {
  count = var.create_private_ca ? 1 : 0
  certificate_authority_arn = aws_acmpca_certificate_authority.this[0].arn

  certificate       = aws_acmpca_certificate.cert[0].certificate
  certificate_chain = aws_acmpca_certificate.cert[0].certificate_chain
}

resource "aws_acmpca_certificate" "cert" {
  count = var.create_private_ca ? 1 : 0
  certificate_authority_arn   = aws_acmpca_certificate_authority.this[0].arn
  certificate_signing_request = aws_acmpca_certificate_authority.this[0].certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = local.years_valid
  }
}

resource "aws_acmpca_certificate_authority" "this" {
  count = var.create_private_ca ? 1 : 0
  certificate_authority_configuration {
    key_algorithm     = var.key_algorithm
    signing_algorithm = var.signing_algorithm

    subject {
      common_name = var.common_name
    }
  }
  
  type = "ROOT"

  revocation_configuration {
    crl_configuration {
      custom_cname       = "crl.${var.common_name}"
      enabled            = true
      expiration_in_days = var.expiration_in_days
      s3_bucket_name     = var.s3_logs_bucket
    }
  }
  
  tags   = var.tags

  depends_on = [aws_s3_bucket_policy.this]
}

#######################################
# MSK Cluster
#######################################
module "msk" {
  source                         = "cloudposse/msk-apache-kafka-cluster/aws"
  version                        = "v1.2.0"
  namespace                      = var.namespace
  name                           = var.name
  vpc_id                         = var.vpc_id
  client_broker                  = var.client_broker
  zone_id                        = var.zone_id
  security_groups                = var.security_groups
  subnet_ids                     = var.subnet_ids
  kafka_version                  = var.kafka_version
  #it was deprecated , now the param is number_of_broker_nodes
  # number_of_broker_nodes         = var.number_of_broker_nodes
  broker_per_zone                = var.broker_per_zone
  broker_instance_type           = var.broker_instance_type
  broker_volume_size             = var.broker_volume_size
  tags                           = var.tags
  certificate_authority_arns     = var.create_private_ca ? [aws_acmpca_certificate_authority.this[0].arn] : []
  client_tls_auth_enabled        = var.client_tls_auth_enabled
  client_sasl_iam_enabled        = var.client_sasl_iam_enabled
  client_sasl_scram_enabled      = var.client_sasl_scram_enabled
  client_sasl_scram_secret_association_arns = var.client_sasl_scram_secret_association_arns
  encryption_in_cluster          = var.encryption_in_cluster
  encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn != null ? var.encryption_at_rest_kms_key_arn : aws_kms_key.this.arn
  cloudwatch_logs_enabled        = var.cloudwatch_logs_enabled
  cloudwatch_logs_log_group      = var.cloudwatch_logs_enabled == true ? var.cloudwatch_logs_log_group : ""
  enhanced_monitoring            = var.enhanced_monitoring
  node_exporter_enabled          = var.node_exporter_enabled
  jmx_exporter_enabled           = var.jmx_exporter_enabled
  s3_logs_bucket                 = var.s3_logs_enabled == true ? var.s3_logs_bucket : ""
  s3_logs_enabled                = var.s3_logs_enabled
  s3_logs_prefix                 = var.s3_logs_enabled == true ? var.s3_logs_prefix : ""

  depends_on = [
    aws_cloudwatch_log_group.msk_cloudwatch_log_group,
    aws_s3_bucket.this,
    aws_acmpca_certificate.cert[0]
  ]
}
