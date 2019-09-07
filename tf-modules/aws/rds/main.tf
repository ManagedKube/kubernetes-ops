locals {
  # Common tags to be assigned to all resources
  common_tags = {
    name         = var.name
    resource_for = var.resource_for
    env          = var.env
    group        = var.group
    application  = var.application
    managed_by   = "Terraform"
  }
}

terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = var.subnet_1_cidr
  availability_zone = var.az_1

  tags = merge(
    local.common_tags,
    {
      "Name" = var.name
    },
  )
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = var.subnet_2_cidr
  availability_zone = var.az_2

  tags = merge(
    local.common_tags,
    {
      "Name" = var.name
    },
  )
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.name}-${var.env}-${var.application}"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = merge(
    local.common_tags,
    {
      "Name" = var.name
    },
  )
}

resource "aws_db_instance" "database" {
  depends_on                  = [aws_security_group.security_group]
  allow_major_version_upgrade = var.allow_major_version_upgrade
  backup_retention_period     = var.backup_retention_period
  deletion_protection         = var.deletion_protection
  identifier                  = "${var.identifier}-${var.env}"
  instance_class              = var.instance_class
  snapshot_identifier         = var.snapshot_id
  name                        = var.name
  username                    = var.username
  password                    = var.password
  parameter_group_name        = aws_db_parameter_group.parameter_group.id
  skip_final_snapshot         = var.skip_final_snapshot
  storage_encrypted           = var.storage_encrypted
  storage_type                = var.storage_type
  allocated_storage           = var.storage
  engine                      = var.engine
  engine_version              = var.engine_version[var.engine]
  db_subnet_group_name        = aws_db_subnet_group.subnet_group.id
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  apply_immediately           = var.apply_immediately
  replicate_source_db         = var.replicate_source_db
  kms_key_id                  = var.kms_key_id
  multi_az                    = var.multi_az

  tags = merge(
    local.common_tags,
    {
      "Name" = var.name
    },
  )
}

resource "aws_security_group" "security_group" {
  name        = "Database-${var.name}-${var.env}"
  description = "Allow traffic to the database"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = var.ingress_allow_port_from
    protocol    = "tcp"
    to_port     = var.ingress_allow_port_to
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = var.egress_allow_port_from
    protocol    = "tcp"
    to_port     = var.egress_allow_port_to
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = var.name
    },
  )
}

resource "aws_db_parameter_group" "parameter_group" {
  name   = "${var.name}-${var.env}-${var.application}"
  family = var.parameter_group_family

  dynamic "parameter" {
    iterator = item
    for_each = var.parameter_group_items
    content {
      name  = item.value.name
      value = item.value.value
    }
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = var.name
    },
  )
}
