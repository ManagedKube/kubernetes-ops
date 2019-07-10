terragrunt = {
  terraform {
    # source = "git::ssh://git@github.q-internal.tech/qadium/terraform-modules.git/kubernetes/gcp/private-gke-networks?ref=master"
    source = "../../../../tf-modules/gcp/vpc/"
  }
  include {
    path = "${find_in_parent_folders()}"
  }
}

region = "us-central1"
region_zone = "us-central1-b"
project_name = "managedkube"
vpc_name = "dev"
# network_name = "devops-gke"
# https://github.q-internal.tech/qadium/devops-docs/wiki/cidr#bgp-allocations
# asn = 65449

public_subnet_cidr_range = "10.20.10.0/24"
private_subnet_cidr_range = "10.20.20.0/24"

bastion_machine_type = "n1-standard-2"
bastion_image = "ubuntu-1810-cosmic-v20190628"
bastion_internal_ip = "10.20.10.253"

internal_services_bastion_cidr = "10.20.10.253/32"

# pods_ip_cidr_range="10.103.96.0/19"
# services_ip_cidr_range="10.104.48.0/20"
#
outbound_through_bastion_tags=["private-subnet", "gke-private-nodes"]
