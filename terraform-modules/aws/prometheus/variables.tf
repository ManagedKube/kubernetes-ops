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
        # Arbitrary name for this instance
        # Will be appended to the tags for the items this instance creates
        instance_name                 = "dev cluster"
        description                   = "To grant access to the remote EKS cluster"
        # The AWS OIDC provider information
        # We will be adding an OIDC provider to this AWS account to trust the
        # external EKS cluster's OIDC provider.  This will grant permissions to
        # this AMP to the remote EKS cluster.
        # One way to get the thumbprint is to go into the AWS console:
        # IAM -> Access Management -> Identiry Provider
        # Then add a provider -> OpenID Connect
        # Add in the EKS OpenID Connect provider URL (can be found in the AWS console in the EKS cluster's overview tab)
        # Click on Get Thumbprint.  It will generate a thumbprint such as: 9e99a48a9960b14926bb7f3b02e22da2b0ab7280
        oidc_provider_url             = "https://oidc.eks.us-east-1.amazonaws.com/id/B4EA44BE30ABD91AC23C475F3237111"
        oidc_provider_client_id_list  = [
          "sts.amazonaws.com"
        ]
        oidc_provider_thumbprint_list = [
          "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
        ]
        # EKS cluster oidc issuer url.  The cluster to give access to this AMP.
        # It could be an EKS OIDC URL from another AWS account
        eks_cluster_oidc_issuer_url   = "https://xxxxxxxxxxxxxxxxxxxxx.sk1.us-east-1.eks.amazonaws.com",
        # Namespace for the OIDC federation sub matching that the source EKS service account this will be used in
        namespace                     = "monitoring",
        environment_name              = "dev",
        # The kubernetes service account name to grant access to.
        # The default here is the name that the kube-prometheus-stack names the service account by default
        kube_service_account_name     = "kube-prometheus-stack-prometheus",
    },
  ]
}
