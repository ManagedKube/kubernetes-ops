resource "aws_mwaa_environment" "this" {
  name               = var.airflow_name
  source_bucket_arn  = var.source_bucket_arn
  dag_s3_path        = var.dag_s3_path
  execution_role_arn = aws_iam_role.example.arn

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
    security_group_ids = [aws_security_group.example.id]
    subnet_ids         = var.subnet_ids
  }

  tags = var.tags
}

data "aws_caller_identity" "current" {}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version                       = "4.14.0"

  create_role             = true
  role_name               = "airflow-${var.airflow_name}"
  role_description        = "Airflow role"
  trusted_role_services   = ["airflow.amazonaws.com","airflow-env.amazonaws.com"]
  custom_role_policy_arns = [aws_iam_policy.policy.arn]
  tags                    = var.tags
}

resource "aws_iam_policy" "policy" {
  name_prefix = "cluster-autoscaler-${var.cluster_name}"
  description = "EKS cluster-autoscaler policy for cluster ${var.eks_cluster_id}"
  policy      = templatefile("default_iam_policy.json", {
    aws_region     = var.aws_region
    aws_account_id = data.aws_caller_identity.current.account_id
    airflow_name   = var.airflow_name
    s3_bucket_name = var.source_bucket_name
  })

  tags = var.tags
}
