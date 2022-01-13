variable "aws_region" {
  type    = string
  default = ""
}

variable "ami" {
  type        = string
  description = "AMI image"
}

variable "key_pair_name" {
  type = string
  default = null
  description = "The ec2 key/pair name"
}

variable "user_ssh_public_key" {
  type = string
  description = "The public key for the key pair"
}

variable "environment_name" {
  type        = string
  description = "The full name of the environment"
}

variable "instance_name" {
  type = string
  description = "The instance name"
}

variable "key_name" {
  type = string
  description = "The AWS Key name"
}

variable "subnet_id" {
  type = string
  description = "The subnet ID to place this instance into"
}

variable "tags" {
  type = map(any)
  description = "The set of tags to place on this node and other resources"
}

variable "node_profile_type" {
  type        = string
  default     = null
  description = "description"
}

variable "instance_config" {
  default = {
    root_installer_device = {
      instance_type         = "m5.4xlarge"
      delete_on_termination = true,
      encrypted             = true,
      iops                  = "",
      kms_key_id            = "",
      volume_size           = 80,
      volume_type           = "gp2",
    }
    ebs_block_device = []
    user_data_inputs = {
      ebs_block_device_1_is_set       = "false"
      ebs_block_device_1_mount_path   = "null"
      ebs_block_device_2_is_set       = "false"
      ebs_block_device_2_mount_path   = "null"
    }
  }
}

variable "aws_iam_role_policy_attachment_list" {
  type        = list(string)
  default     = []
  description = "A list of IAM policy ARNs to attached to this node's instance profile"
}

variable "security_group_list" {
  type        = list(string)
  default     = []
  description = "The list of security group IDs to apply to this instance"
}
