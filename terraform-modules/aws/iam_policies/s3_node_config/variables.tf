variable "name" {
  type        = string
  default     = "featurespace-s3-ec2-node_configs-"
  description = "The full name of the policy"
}

variable "environment_name" {
  type        = string
  description = "The full name of the environment"
}

variable "tags" {
  type = map(any)
  description = "The set of tags to place on this node and other resources"
}
