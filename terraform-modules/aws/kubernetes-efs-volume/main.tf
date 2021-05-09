terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.1.0"
    }
  }
}


module "efs" {
  source  = "cloudposse/efs/aws"
  version = "0.30.1"

  namespace       = var.efs_namespace
  stage           = var.environment_name
  name            = var.efs_name
  region          = var.aws_region
  vpc_id          = var.vpc_id
  subnets         = var.subnets
  security_groups = var.security_groups

  tags = var.tags
}

resource "kubernetes_storage_class" "storage_class" {
  metadata {
    name = "${var.efs_name}-sc"
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = var.reclaim_policy
  # https://github.com/kubernetes-sigs/aws-efs-csi-driver/tree/master/examples/kubernetes/dynamic_provisioning#dynamic-provisioning
  parameters = {
    provisioningMode = var.storage_class_parameters_provisioningMode
    directoryPerms   = var.storage_class_parameters_directoryPerms
    gidRangeStart    = var.storage_class_parameters_gidRangeStart
    gidRangeEnd      = var.storage_class_parameters_gidRangeEnd
    basePath         = var.storage_class_parameters_basePath
  }
  mount_options = ["tls"]

  depends_on = [
    module.efs
  ]
}

resource "kubernetes_persistent_volume" "pv" {
  metadata {
    name = var.efs_name
  }
  spec {
    storage_class_name               = "${var.efs_name}-sc"
    persistent_volume_reclaim_policy = var.persistent_volume_reclaim_policy
    capacity = {
      storage = var.storage_capacity
    }
    access_modes  = var.access_modes
    mount_options = ["tls"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = module.efs.id
        volume_attributes = {
          encryptInTransit = true
        }
      }
    }
  }

  depends_on = [
    kubernetes_storage_class.storage_class
  ]
}

resource "kubernetes_persistent_volume_claim" "pvc" {
  metadata {
    name      = var.efs_name
    namespace = var.kubernetes_namespace
  }
  spec {
    access_modes = var.access_modes
    resources {
      requests = {
        storage = var.storage_capacity
      }
    }
    volume_name        = kubernetes_persistent_volume.pv.metadata.0.name
    storage_class_name = "${var.efs_name}-sc"
  }

  depends_on = [
    kubernetes_persistent_volume.pv
  ]
}
