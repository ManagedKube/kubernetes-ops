include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../tf-modules/gcp/firewall-rules/prometheus"

}

inputs = {
  region = "us-central1-a"
  project_name = "managedkube"

  network_name = trimspace(run_cmd("terragrunt", "output", "network_name", "--terragrunt-working-dir", "../../vpc"))

  source_range_list = ["10.0.0.0/8"]
}
