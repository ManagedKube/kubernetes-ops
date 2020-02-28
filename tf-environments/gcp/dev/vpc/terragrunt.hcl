include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../tf-modules/gcp/vpc/"
}

inputs = {
  # region = "us-central1" # specified in ../_env_defaults/gcp.tfars
  bastion_region_zone = "us-central1-b"
  // project_name = "managedkube"
  vpc_name = "dev"

  public_subnet_cidr_range = "10.32.1.0/24"
  private_subnet_cidr_range = "10.32.5.0/24"

  bastion_machine_type = "n1-standard-2"
  bastion_image = "ubuntu-1810-cosmic-v20190628"
  bastion_internal_ip = "10.32.1.253"

  internal_services_bastion_cidr = "10.32.1.253/32"

  outbound_through_bastion_tags=["private-subnet", "gke-private-nodes"]
  outbound_through_nat_tags=["private-subnet", "gke-private-nodes"]
}
