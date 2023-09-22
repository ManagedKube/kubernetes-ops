variable helm_version {
  type        = string
  default     = "39.6.0"
  description = "Helm chart version"
}

variable verify {
  type        = bool
  default     = false
  description = "Verify the helm download"
}

variable namespace {
  type        = string
  default     = "monitoring"
  description = "Namespace to install in"
}

variable chart_name {
  type        = string
  default     = "kube-prometheus-stack"
  description = "Name to set the helm deployment to"
}

variable helm_values {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "aws_account_id" {
  type        = string
  default     = ""
  description = "AWS account ID.  Used in creating IAM assumable role if enabled"
}

variable "eks_cluster_oidc_issuer_url" {
  type        = string
  default     = ""
  description = "EKS cluster oidc issuer url"
}

variable "enable_iam_assumable_role_grafana" {
  type        = bool
  default     = false
  description = "Enable the creation of an AWS IAM assumable role that is attached to the Grafana kubernetes service account.  Use case is to give Grafana access to AWS Cloudwatch log via an assumable role."
}

variable "environment_name" {
  type        = string
  default     = "env"
  description = "An environment name to attach to some resources.  Optional only needed if you are going to create more than one of these items in an AWS account"
}

# Sample AWS IAM policy: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/iam-identity-based-access-control-cwl.html#managed-policies-cwl
variable "aws_policy_grafana" {
  type        = string
  default     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:Describe*",
                "logs:Get*",
                "logs:List*",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:TestMetricFilter",
                "logs:FilterLogEvents",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:DescribeAlarms"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
  description = "The AWS policy for the Grafana AWS role.  The default is a read only role to all Cloudwatch logs."
}
