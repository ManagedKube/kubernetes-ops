variable aws_region {
    default = "us-east-1"
}
variable tags {}
variable "vpc_id" {
    default = ""
}
variable private_subnets {
    type = list
    default = []
}
variable public_subnets {
    type = list
    default = []
}

variable cluster_name {
    default = "test-cluster"
}

variable cluster_version {
    default = "1.18"
}

variable enable_irsa {
  type        = bool
  default     = true
  description = "enable_irsa"
}

variable cluster_endpoint_public_access {
  type        = bool
  default     = true
  description = "Enable or disable Kube API public access"
}

variable cluster_endpoint_public_access_cidrs {
  type        = list
  default     = [
    "0.0.0.0/0"
  ]
  description = "Kube API public endpoint allow access cidrs"
}

variable map_roles {
  type        = list(map)
  default     = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
  description = "A list of roles to give permission to access this cluster"
}

variable map_users {
  type        = list(map)
  default     = [
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

variable node_groups {
  type        = any
  default     = {
    ng1 = {
      disk_size        = 20
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      instance_type    = "t2.small"
      additional_tags  = {
        Name = "foo",
      }
      k8s_labels       = {}
    }
  }
  description = "node group(s) configurations"
}
