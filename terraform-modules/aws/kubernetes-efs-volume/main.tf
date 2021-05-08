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
  reclaim_policy      = "Retain"
  # https://github.com/kubernetes-sigs/aws-efs-csi-driver/tree/master/examples/kubernetes/dynamic_provisioning#dynamic-provisioning
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = module.efs.id
    directoryPerms   = "700"
    gidRangeStart    = "1000"
    gidRangeEnd      = "2000"
    basePath         = "/"
  }
  # mount_options = ["file_mode=0700", "dir_mode=0777", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]
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
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      nfs {
        path   = "/"
        server = module.efs.id
      }
    }
  }

  depends_on = [
    module.efs
  ]
}

resource "kubernetes_persistent_volume_claim" "pvc" {
  metadata {
    name      = var.efs_name
    namespace = var.kubernetes_namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "2Gi"
      }
    }
    volume_name        = kubernetes_persistent_volume.pv.metadata.0.name
    storage_class_name = "${var.efs_name}-sc"
  }
}
