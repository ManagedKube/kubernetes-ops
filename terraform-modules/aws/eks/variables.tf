variable "aws_region" {
  default = "us-east-1"
}
variable "tags" {
  type = map(any)
}
variable "vpc_id" {
  default = ""
}
variable "private_subnets" {
  type    = list(any)
  default = []
}
variable "public_subnets" {
  type    = list(any)
  default = []
}

variable "k8s_subnets" {
  type        = list(any)
  default     = []
  description = "Subnet IDs to place the EKS nodes into"
}

variable "cluster_name" {
  default = "test-cluster"
}

variable "cluster_version" {
  default = "1.18"
}

variable "enable_irsa" {
  type        = bool
  default     = true
  description = "enable_irsa"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  default     = true
  description = "Enable or disable Kube API public access"
}

variable "cluster_endpoint_public_access_cidrs" {
  type = list(any)
  default = [
    "0.0.0.0/0"
  ]
  description = "Kube API public endpoint allow access cidrs"
}

variable "map_roles" {
  type = list(any)
  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
  description = "A list of roles to give permission to access this cluster"
}

variable "map_users" {
  type = list(any)
  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
  description = "A list of users to give permission to access this cluster"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
  default     = []
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default = {
    ng1 = {
      disk_size      = 20
      desired_size   = 1
      max_sise       = 1
      min_size       = 1
      instance_types = ["t2.small"]
      additional_tags = {
        Name = "foo",
      }
      k8s_labels = {}
    }
  }
}

variable "cluster_enabled_log_types" {
  type = list(string)
  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  description = "The Kubernetes log types to enable"
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  default     = 90
  description = "Log retention in days"
}

variable "cluster_endpoint_private_access" {
  type        = bool
  default     = false
  description = "Enable or disable Kube API private access"
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created"
  type        = any
  default     = {}
}

variable "kubectl_binary" {
  description = "The path the the kubectl binary.  Used for applying the aws-auth configmap"
  type        = string
  default     = "kubectl"
  # This could be a path.  If running from Github Actions, you can download kubectl to: /github/workspace/kubectl and set this parameter to that location
}

# Source on config params: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/node_groups.tf#L166-L186
variable "node_security_group_additional_rules" {
  type        = any
  description = "Additional security groups to add to the node_group"
  default     = {
    allow_all_internal_ranges = {
      description = "Allow inbound to istiod for envoy to request a workload identity (cert)"
      protocol    = "all"
      from_port   = 0
      to_port     = 65535
      type        = "ingress"
      cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "100.64.0.0/10"]
    }
    #
    # The alternative is to start adding specific rules for each item.  It became a little too
    # much to add even for just one service such as istio.  Then you will have to start adding
    # rules for nginx-ingress webhook validation, prometheus, etc.
    #
    # istio_webhook = {
    #   description = "Allow EKS API to reach Istio for CRD validation"
    #   protocol    = "tcp"
    #   from_port   = 15017
    #   to_port     = 15017
    #   type        = "ingress"
    #   # This denotes that it should put the cluster's SG group ID as the source.  This
    #   # would include the EKS API as the source
    #   source_cluster_security_group = true
    # }
    # istio_workload_cert_request = {
    #   description = "Allow inbound to istiod for envoy to request a workload identity (cert)"
    #   protocol    = "tcp"
    #   from_port   = 15012
    #   to_port     = 15012
    #   type        = "ingress"
    #   # cidr_blocks = ["172.16.0.0/12"]
    #   # 'self' denotes that the source is the node group's SG ID
    #   self        = true
    # }
    # istio_envoy_healthchecks = {
    #   description = "Allow inbound to istio envoy healthcheck port"
    #   protocol    = "tcp"
    #   from_port   = 15021
    #   to_port     = 15021
    #   type        = "ingress"
    #   source_cluster_security_group = true
    # }
  }
}
