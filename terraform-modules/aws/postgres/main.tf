module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = "${var.identifier}-${var.name}"
  description = "PostgreSQL security group"
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port = 5432
      to_port   = 5432
      protocol  = "tcp"

      description = "PostgreSQL access from within VPC"
      cidr_blocks = var.vpc_cidr_block
    },
  ]

  tags = var.tags
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = var.identifier

  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family
  major_engine_version = var.major_engine_version
  instance_class       = var.instance_class

  storage_type          = var.storage_type
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  name     = var.name
  username = var.username
  password = var.password
  port     = 5432

  multi_az               = true
  subnet_ids             = var.private_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  monitoring_role_name                  = "${var.identifier}-${var.name}"
  create_monitoring_role                = true
  monitoring_interval                   = 60

  parameters = var.parameters

  tags = var.tags
}
