terraform {
  # backend "s3" {
  # }
  backend "gcs" {}
}

provider "google" {
  region      = var.region
  project     = var.project_name
  credentials = file(var.credentials_file_path)
  version     = "~> v3.10.0"
}

provider "google-beta" {
  region      = var.region
  project     = var.project_name
  credentials = file(var.credentials_file_path)
  version     = "~> v3.10.0"
}

resource "google_compute_network" "main" {
  name                    = var.vpc_name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "private_subnet" {
  name                     = "${var.vpc_name}-private-subnet"
  ip_cidr_range            = var.private_subnet_cidr_range
  network                  = google_compute_network.main.self_link
  region                   = var.region
  private_ip_google_access = "true"
}

resource "google_compute_subnetwork" "public_subnet" {
  name                     = "${var.vpc_name}-public-subnet"
  ip_cidr_range            = var.public_subnet_cidr_range
  network                  = google_compute_network.main.self_link
  region                   = var.region
  private_ip_google_access = "true"
}

###################################################
# GCP Cloud NAT
###################################################
resource "google_compute_router" "router" {
  name    = "${var.vpc_name}-outbound-through-nat"
  region  = var.region
  network = google_compute_network.main.self_link
  bgp {
    asn = 64514
  }
}

# Using static IPs created outside of this Terraform module.
data "google_compute_address" "address" {
  count = var.number_of_nat_ip_address_to_use
  name = "${var.vpc_name}-nat-external-address-${count.index}"
}

resource "google_compute_router_nat" "advanced-nat" {
  provider               = google-beta
  name                   = "${var.vpc_name}-nat-1"
  router                 = google_compute_router.router.name
  region                 = var.region

  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = data.google_compute_address.address[*].self_link

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
