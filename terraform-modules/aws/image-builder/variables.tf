variable "custom_prefix" {
  description = "A custom prefix to add for each EC2 build image service name."
  type        = string
}

variable "aws_region" {
  description = "The AWS region you want to target for this deployment."
  type        = string
}

variable "pipeline_name" {
  description = "Name of the image pipeline."
  type        = string
  default     = "pipeline"
}

variable "pipeline_enhanced_image_metadata_enabled" {
  description = "Whether additional information about the image being created is collected."
  type        = bool
  default     = true
}

variable "recipe_name" {
  description = "TName of the image recipe."
  type        = string
  default     = "image"
}

variable "recipe_version" {
  description = "The version of your image recipe."
  type        = string
  default     = "1.0.0"
}

variable "recipe_device_name" {
  description = "Name of the disk device. For example, /dev/sda or /dev/xvdb."
  type        = string
  default     = "/dev/sda1"
}

variable "recipe_ebs_delete_on_termination" {
  description = "Whether to delete the volume on termination. Defaults to unset, which is the value inherited from the parent image."
  type        = bool
  default     = false
}

variable "recipe_ebs_volume_size" {
  description = "Size of the volume, in GiB."
  type        = number
  default     = 10
}

variable "recipe_ebs_volume_type" {
  description = "Type of the volume. For example, gp2 or io2."
  type        = string
  default     = "gp2"
}

variable "recipe_ebs_volume_encrypted" {
  description = "Whether to encrypt the volume. Defaults to unset, which is the value inherited from the parent image."
  type        = bool
  default     = true
}

variable "recipe_parent_image" {
  description = "Platform of the image recipe."
  type        = string
}

variable "recipe_working_directory" {
  description = "The working directory to be used during build and test workflows."
  type        = string
  default     = "/tmp"
}

variable "infrastructure_configuration_name" {
  description = "Name for the configuration."
  type        = string
  default     = "infra"
}

variable "infrastructure_configuration_subnet_id" {
  description = "EC2 Subnet identifier. Also requires security_group_ids argument."
  type        = string
}

variable "infrastructure_configuration_security_group_ids" {
  description = "Set of EC2 Security Group identifiers."
  type        = list(string)
}

variable "distribution_configuration_name" {
  description = "Name of the distribution configuration."
  type        = string
  default     = "distro"
}


variable "component_name" {
  description = "Name of the component."
  type        = string
  default     = "component"
}

variable "component_data" {
  description = "Inline YAML string with data of the component. Terraform will only perform drift detection of its value when present in a configuration."
  type        = string
}

variable "component_version" {
  description = "Version of the component."
  type        = string
  default     = "1.0.0"
}

variable "aws_iam_instance_profile_name" {
  description = "A custom name for an instance profile. Can be a string of characters consisting of upper and lowercase alphanumeric characters and these special characters: _, +, =, ,, ., @, -. Spaces are not allowed."
  type        = string
  default     = "InstanceProfileForEC2Builder"
}

variable "aws_iam_role_name" {
  description = "A custom name for an IAM role policy."
  type        = string
  default     = "RoleForEC2Builder"
}


variable "infastructure_configuration_instance_types" {
  description = "Set of EC2 Instance Types."
  type        = list(string)
}

variable "tags" {
  description = "Key-value map of resource tags to assign to the configuration. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(any)
}