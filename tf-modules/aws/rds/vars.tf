# Networking

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-xxxxxx"
}

variable "subnet_1_cidr" {
  default     = "172.16.0.0/28"
  description = "Your AZ"
}

variable "subnet_2_cidr" {
  default     = "172.16.0.16/28"
  description = "Your AZ"
}

variable "az_1" {
  default     = "us-east-1b"
  description = "Your Az1, use AWS CLI to find your account specific"
}

variable "az_2" {
  default     = "us-east-1c"
  description = "Your Az2, use AWS CLI to find your account specific"
}

# RDS Parameters

variable "username" {
  default     = "DB_USER"
  description = "User name"
}

variable "password" {
  default     = "DB_PASSWORD"
  description = "password, provide through your ENV variables"
}

variable "instance_class" {
  default = "db.t3.medium"
}

variable "name" {
  default = "rds-generic"
}

variable "identifier" {
  default = "rds-generic"
}

variable "env" {
  default = "dev"
}

variable "group" {
  description = "The team or group this resource belongs to"
  default     = "default"
}

variable "application" {
  description = "The application this belongs to"
  default     = "default"
}

variable "resource_for" {
  description = "The type of resource this is for"
  default     = "rds"
}

variable "region" {
  default = "us-east-1"
}

variable "ingress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "ingress_allow_port_from" {
  default = 3306
}

variable "ingress_allow_port_to" {
  default = 3306
}

variable "egress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "egress_allow_port_from" {
  default = 3306
}

variable "egress_allow_port_to" {
  default = 3306
}

variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "mysql"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"

  default = {
    mysql    = "5.6.41"
    postgres = "9.6.8"
  }
}

variable "parameter_group_family" {
  default = "mysql5.6"
}

variable "allow_major_version_upgrade" {
  default = false
}

variable "snapshot_id" {
  default = ""
}

variable "apply_immediately" {
  description = "When to apply change. Set to true if right now or false if on next maintenance window"
  default     = "false"
}

variable "replicate_source_db" {
  default     = ""
}

variable "kms_key_id" {
  default     = ""
  description = "The local KMS Key ARN to use.  Local to this replica."
}

variable "multi_az" {
  default    = true
}

variable "storage_encrypted" {
  default    = true
}

variable "storage_type" {
  default   = "gp2"
}

variable "skip_final_snapshot" {
  default   = true
}

variable "deletion_protection" {
  default   = true
}

variable "backup_retention_period" {
  default   = 10
}

variable "parameter_group_items" {
  type        = list
  description = "list of ingress ports"
  default     = [
    {
      name  = "character_set_server"
      value = "utf8"
    },
    {
      name  = "character_set_client"
      value = "utf8"
    },
  ]
}
