include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../tf-modules/gcp/nodepool/"

  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

     arguments = [
      "-var-file=${get_terragrunt_dir()}/../../_env_defaults/gcp.tfvars",
     ]
  }
}

inputs = {

  cluster_name = trimspace(run_cmd("terragrunt", "output", "cluster_name", "--terragrunt-working-dir", "../../gke-cluster"))
  node_pool_name = "pool-1"

  initial_node_count = "1"
  min_node_count = "0"
  max_node_count = "2"
  is_preemtible = true
  machine_type = "n1-standard-2"
  disk_size_gb = "100"
  auto_upgrade = true

  image_type = "COS"

  # These represent the "gke-defaults" scope list
  oauth_scopes = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append",
  ]

  # Kubernetes node labels
  labels = {}
  // {
  //   foo = "bar",
  //   foo2 = "bar2",
  // }

  # GCP node labels and firewall labels
  tags = []
  // ["foo", "bar"]

  # Kubernetes taints
  taints = []
  // [
  //   {
  //     effect = "NO_SCHEDULE"
  //     key    = "bar"
  //     value  = "foo"
  //   },
  //   {
  //     effect = "NO_SCHEDULE"
  //     key    = "bar2"
  //     value  = "foo2"
  //   },
  // ]

}

dependencies {
  paths = ["../gke-cluster"]
}
