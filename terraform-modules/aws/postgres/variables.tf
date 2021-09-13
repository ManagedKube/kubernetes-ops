variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
}

variable "private_subnets" {
  description = "A list of private subnets"
  type        = list(any)
}

variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
}
variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "postgres"
}
variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "11.12"
}
variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "postgres11"
}
variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = "11"
}
variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.large"
}
variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not."
  type        = string
  default     = "gp2"
}
variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = 100
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 1024
}
variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}
variable "name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = null
}
variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = null
}
variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = null
}
variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}
variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "03:00-06:00"
}
variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = "0"
}
variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = true
}
variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = false
}
variable "parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]
}
variable "tags" {
  type = map(any)
  default = {
    ops_env              = "staging"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_owners           = "devops",
    ops_source_repo_path = "terraform-module/aws/postgres"
  }
}
