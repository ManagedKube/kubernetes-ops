variable "workspace_alias" {
  default = "prometheus-test"
}

variable "tags" {
  type        = map(any)
  description = "AWS tags"
}

variable "instance_name" {
  type        = string
  default     = "env"
  description = "An instance name to attach to some resources.  Optional only needed if you are going to create more than one of these items in an AWS account"
}

variable "account_id" {
  type        = string
  default     = null
  description = "The account_id of your AWS Account. This allows sure the use of the account number in the role to mitigate issue of aws_caller_id showing *** by obtaining the value of account_id "
}

variable "iam_access_grant_list" {
  type        = list
  description = "The list of IAM roles for granting various EKS cluster(s) permissions to perform a remote write to this AMP instance."
  default     = [
    {
        # EKS cluster oidc issuer url
        eks_cluster_oidc_issuer_url = "https://foo",
        # Namespace for the OIDC federation sub matching that the source EKS service account this will be used in
        namespace                   = "monitoring",
        environment_name            = "dev",
    },
  ]
}
