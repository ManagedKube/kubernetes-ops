include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../tf-modules/gcp/private-gke-cluster/"

  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

     arguments = [
      "-var-file=${get_terragrunt_dir()}/../_env_defaults/gcp.tfvars",
     ]
  }
}

inputs = {
  vpc_name = trimspace(run_cmd("terragrunt", "output", "network_name", "--terragrunt-working-dir", "../vpc"))
  network_name = trimspace(run_cmd("terragrunt", "output", "network_name", "--terragrunt-working-dir", "../vpc"))
  cluster_name = "dev"
  private_subnet_name = trimspace(run_cmd("terragrunt", "output", "private_subnet_name", "--terragrunt-working-dir", "../gke-subnets"))

  enable_private_kube_master_endpoint = false

  gke_version = "1.16.5-gke.2"
  initial_node_count = "1"

  master_ipv4_cidr_block="10.32.11.0/28"

  master_authorized_networks_cidr = [
    { cidr_block = "10.0.0.0/8", display_name = "10x" },
    { cidr_block = "172.16.0.0/12", display_name = "172x" },
    { cidr_block = "192.168.0.0/16", display_name = "192x" },
    { cidr_block = "38.30.8.138/32", display_name = "home" },
    { cidr_block = "35.222.67.76/32", display_name = "gar-vpn" },
    { cidr_block = "12.190.239.210/32", display_name = "gar-vpn-2" },
  ]

  outbound_through_nat_tags=["private-subnet", "gke-private-nodes"]

  cluster_autoscaling_enabled = true

  resource_limits_enable = [
    {
      type = "cpu",
      max = 10,
      min = 0,
    }, {
      type = "memory",
      max = 16,
      min = 0,
    }
  ]

  release_channel_channel = "RAPID"

  enable_intranode_visibility = true
}

dependencies {
  paths = ["../vpc"]
}
