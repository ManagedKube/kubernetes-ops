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

variable "manage_aws_auth" {
  description = "Applies the aws_auth into the EKS cluster"
  type        = bool
  default     = true
}

variable "aws_auth_additional_labels" {
  description = "Additional kubernetes labels applied on aws-auth ConfigMap"
  default     = {}
  type        = map(string)
}
