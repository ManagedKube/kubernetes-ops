terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.0.1"
    }
  }
}


resource "mongodbatlas_cluster" "cluster" {
  project_id   = var.mongodbatlas_projectid
  name         = var.cluster_name
  cluster_type = var.cluster_type
  replication_specs {
    num_shards = var.num_shards
    regions_config {
      region_name     = var.region_name
      electable_nodes = var.electable_nodes
      priority        = var.priority
      read_only_nodes = var.read_only_nodes
    }
  }
  cloud_backup                                    = var.cloud_backup
  auto_scaling_disk_gb_enabled                    = var.auto_scaling_disk_gb_enabled
  auto_scaling_compute_enabled                    = var.auto_scaling_compute_enabled
  auto_scaling_compute_scale_down_enabled         = var.auto_scaling_compute_scale_down_enabled
  provider_auto_scaling_compute_max_instance_size = var.provider_auto_scaling_compute_max_instance_size
  provider_auto_scaling_compute_min_instance_size = var.provider_auto_scaling_compute_min_instance_size
  mongo_db_major_version                          = var.mongo_db_major_version

  //Provider Settings "block"
  provider_name               = var.provider_name
  disk_size_gb                = var.disk_size_gb
  provider_instance_size_name = var.provider_instance_size_name
  advanced_configuration {
    javascript_enabled           = var.javascript_enabled
    minimum_enabled_tls_protocol = var.minimum_enabled_tls_protocol
  }
}

resource "mongodbatlas_privatelink_endpoint" "mongodbatlas" {
  project_id    = var.mongodbatlas_projectid
  provider_name = var.provider_name
  region        = var.aws_region
}

resource "aws_security_group" "this" {
  name        = "MongoDB - ${var.cluster_name}"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rule
    content {
      description      = ingress.value["description"]
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.egress_rule
    content {
      description      = egress.value["description"]
      from_port        = egress.value["from_port"]
      to_port          = egress.value["to_port"]
      protocol         = egress.value["protocol"]
      cidr_blocks      = egress.value["cidr_blocks"]
      ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
    }
  }

  tags = var.tags
}

resource "aws_vpc_endpoint" "mongodbatlas" {
  vpc_id             = var.vpc_id
  service_name       = mongodbatlas_privatelink_endpoint.mongodbatlas.endpoint_service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.this.id]
  tags               = var.tags
}

resource "mongodbatlas_privatelink_endpoint_service" "atlasplink" {
  project_id          = mongodbatlas_privatelink_endpoint.mongodbatlas.project_id
  endpoint_service_id = aws_vpc_endpoint.mongodbatlas.id
  private_link_id     = mongodbatlas_privatelink_endpoint.mongodbatlas.id
  provider_name       = var.provider_name
}
