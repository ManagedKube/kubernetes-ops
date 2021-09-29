variable "aws_region" {
  default = "us-east-1"
}
variable "environment_name" {}
variable "vpc_cidr" {}
variable "tags" {
  type    = map(any)
  default = {}
}

variable "azs" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type    = list(any)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "enable_vpn_gateway" {
  type    = bool
  default = true
}

variable "cluster_name" {
  type        = string
  default     = "none"
  description = "The cluster name for the Kubernetes tags on the subnets"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable dns hostname resolution"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable dns support"
}

variable "secondary_cidrs" {
  type        = list(string)
  default     = ["100.64.0.0/16"]
  description = "optional list of secondary cidr blocks"
}

variable "k8s_worker_subnets" {
  type        = list(string)
  default     = ["100.64.0.0/20", "100.64.16.0/20", "100.64.32.0/20"]
  description = "list of alternate secondary cidrs for kubernetes workers"
}

variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = list(string)
  default     = []
}
