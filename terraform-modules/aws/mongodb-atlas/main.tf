terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.1.1"
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


resource "aws_vpc_endpoint" "mongodbatlas" {
  vpc_id             = var.vpc_id
  service_name       = mongodbatlas_privatelink_endpoint.mongodbatlas.endpoint_service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
  tags               = var.tags
}

resource "mongodbatlas_privatelink_endpoint_service" "atlasplink" {
  project_id          = mongodbatlas_privatelink_endpoint.mongodbatlas.project_id
  endpoint_service_id = aws_vpc_endpoint.mongodbatlas.id
  private_link_id     = mongodbatlas_privatelink_endpoint.mongodbatlas.id
  provider_name       = var.provider_name
}

resource "mongodbatlas_database_user" "featurespace_app" {
  username           = var.x509_admin_username
  x509_type          = var.x509_type
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "$external"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }
}

resource "mongodbatlas_database_user" "admin" {
  username           = "admin"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}

resource "mongodbatlas_database_user" "aric_admin" {
  username           = "aric_admin"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}

resource "mongodbatlas_database_user" "aric_configuration" {
  username           = "aric_configuration"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "configuration"
  }

}

resource "mongodbatlas_database_user" "aric_eventapi" {
  username           = "aric_eventapi"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "lookupdecorator"
  }

  roles {
    role_name     = "readWrite"
    database_name = "anomalies"
  }

  roles {
    role_name     = "readWrite"
    database_name = "dedup"
  }

}

resource "mongodbatlas_database_user" "aric_linker" {
  username           = "aric_linker"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "links"
  }

}


resource "mongodbatlas_database_user" "aric_monitoring" {
  username           = "aric_monitoring"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "test"
  }

  roles {
    role_name     = "readWrite"
    database_name = "monitor-test"
  }

  roles {
    role_name     = "readWrite"
    database_name = "dashboard-stats"
  }

  roles {
    role_name     = "readWrite"
    database_name = "datastorestats"
  }

  roles {
    role_name     = "readWrite"
    database_name = "aric-schemas"
  }

  roles {
    role_name     = "readWrite"
    database_name = "storm-stats"
  }

  roles {
    role_name     = "readWrite"
    database_name = "monitoring-results"
  }

  roles {
    role_name     = "readWrite"
    database_name = "modelmetrics"
  }

  roles {
    role_name     = "read"
    database_name = "metrics"
  }

  roles {
    role_name     = "read"
    database_name = "metrics"
  }

  roles {
    role_name     = "read"
    database_name = "state"
  }

  roles {
    role_name     = "read"
    database_name = "local"
  }

  roles {
    role_name     = "clusterMonitor"
    database_name = "admin"
  }
}


resource "mongodbatlas_database_user" "aric_reports" {
  username           = "aric_reports"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "aric-ui"
  }
}

resource "mongodbatlas_database_user" "aric_topology" {
  username           = "aric_topology"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "watches"
  }

  roles {
    role_name     = "readWrite"
    database_name = "mappings"
  }

  roles {
    role_name     = "readWrite"
    database_name = "storm"
  }

  roles {
    role_name     = "readWrite"
    database_name = "migrations"
  }

  roles {
    role_name     = "readWrite"
    database_name = "state"
  }

  roles {
    role_name     = "readWrite"
    database_name = "metrics"
  }

  roles {
    role_name     = "readWrite"
    database_name = "analytics"
  }

  roles {
    role_name     = "readWrite"
    database_name = "batch"
  }
}


resource "mongodbatlas_database_user" "aric_uiServer" {
  username           = "aric_uiServer"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "aric-ui"
  }

  roles {
    role_name     = "read"
    database_name = "dashboard-stats"
  }

  roles {
    role_name     = "read"
    database_name = "links"
  }

  roles {
    role_name     = "read"
    database_name = "state"
  }
}

resource "mongodbatlas_database_user" "aric_uiWriter" {
  username           = "aric_uiWriter"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "aric-ui"
  }
}

resource "mongodbatlas_database_user" "aric_upgrade" {
  username           = "aric_upgrade"
  password           = var.user_password
  project_id         = var.mongodbatlas_projectid
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "migrations"
  }
}
