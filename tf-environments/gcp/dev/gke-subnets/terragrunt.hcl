include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../tf-modules/gcp/gke-subnets/"
}

inputs = {
  vpc_name = "dev"
  region = "us-central1"
  network_name = "dev"

  services_ip_cidr_range="10.32.64.0/19"
  pods_ip_cidr_range="10.36.0.0/14"    # 1024 max nodes

  #####################
  # networking
  #####################
  public_subnet_cidr_range = "10.32.16.0/20"
  private_subnet_cidr_range = "10.32.32.0/20"

}
