resource "aws_mwaa_environment" "this" {
  name               = var.airflow_name
  airflow_version    = var.airflow_version
  environment_class  = var.environment_class
  max_workers        = var.max_workers
  min_workers        = var.min_workers
  source_bucket_arn  = aws_s3_bucket.mwaa.arn
  dag_s3_path        = var.dag_s3_path
  execution_role_arn = module.iam_assumable_role_admin.iam_role_arn
  webserver_access_mode = var.webserver_access_mode

  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = var.dag_processing_log_level
    }

    scheduler_logs {
      enabled   = true
      log_level = var.scheduler_log_level
    }

    task_logs {
      enabled   = true
      log_level = var.task_log_level
    }

    webserver_logs {
      enabled   = true
      log_level = var.webserver_log_level
    }

    worker_logs {
      enabled   = true
      log_level = var.worker_log_level
    }
  }

  network_configuration {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = var.subnet_ids
  }

  tags = var.tags
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "mwaa" {
  bucket = var.source_bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.mwaa.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.mwaa.id
  acl    = "private"
}

# Using the default AWS KMS master key
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.mwaa.arn

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256" #"aws:kms"
    }
  }
}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version                       = "5.11.2"

  create_role             = true
  role_name               = "airflow-${var.airflow_name}"
  role_description        = "Airflow role"
  trusted_role_services   = ["airflow.amazonaws.com","airflow-env.amazonaws.com"]
  custom_role_policy_arns = [aws_iam_policy.policy.arn]
  role_requires_mfa       = false
  tags                    = var.tags
}

resource "aws_iam_policy" "policy" {
  name_prefix = "cluster-autoscaler-${var.airflow_name}"
  description = "Airflow policy"
  policy      = templatefile("default_iam_policy.json", {
    aws_region     = var.aws_region
    aws_account_id = data.aws_caller_identity.current.account_id
    airflow_name   = var.airflow_name
    s3_bucket_name = var.source_bucket_name
  })

  tags = var.tags
}

resource "aws_security_group" "this" {
  name        = var.airflow_name
  description = "Airflow security group"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}
