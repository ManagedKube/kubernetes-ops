terraform {
  backend "s3" {}
}

provider "google" {
  region      = "${var.region}"
  project     = "${var.project_name}"
  credentials = "${file("${var.credentials_file_path}")}"
  version     = "~> 0.1.3"
}

provider "google-beta" {
  region      = "${var.region}"
  project     = "${var.project_name}"
  credentials = "${file("${var.credentials_file_path}")}"
  version     = "~> 1.20"
}

resource "google_compute_network" "main" {
  name                    = "${var.vpc_name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "private_subnet" {
  name                     = "${var.vpc_name}-private-subnet"
  ip_cidr_range            = "${var.private_subnet_cidr_range}"
  network                  = "${google_compute_network.main.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = "true"
}

resource "google_compute_subnetwork" "public_subnet" {
  name                     = "${var.vpc_name}-public-subnet"
  ip_cidr_range            = "${var.public_subnet_cidr_range}"
  network                  = "${google_compute_network.main.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = "true"
}

###################################################
# GCP Cloud NAT
###################################################
resource "google_compute_router" "router" {
  name    = "router"
  region  = "${var.region}"
  network = "${google_compute_network.main.self_link}"
  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "address" {
  count  = 2
  name   = "${var.vpc_name}-nat-external-address-${count.index}"
  region = "us-central1"
}

resource "google_compute_router_nat" "advanced-nat" {
  provider                           = "google-beta"
  name                               = "${var.vpc_name}-nat-1"
  router                             = "${google_compute_router.router.name}"
  region                             = "us-central1"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = ["${google_compute_address.address.*.self_link}"]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                     = "${google_compute_subnetwork.private_subnet.self_link}"
    source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
  }
  # log_config {
  #   filter = "TRANSLATIONS_ONLY"
  #   enable = true
  # }
}

###################################################
# Bastion host
###################################################
resource "google_compute_address" "bastion_ip" {
  name = "${var.vpc_name}-bastion-b-address"
}

resource "google_compute_instance" "bastion" {
  name           = "${var.vpc_name}-bastion-b"
  machine_type   = "${var.bastion_machine_type}"
  zone           = "${var.region_zone}"
  can_ip_forward = "true"

  tags = ["bastion"]

  boot_disk {
    initialize_params {
      image = "${var.bastion_image}"
      size  = "10"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.public_subnet.name}"
    address    = "${var.bastion_internal_ip}"

    access_config {
      nat_ip = "${google_compute_address.bastion_ip.address}"
    }
  }
}

resource "google_compute_firewall" "allow_bastion_traffic" {
  name    = "${var.vpc_name}-allow-internal-services-bastion"
  network = "${google_compute_network.main.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.internal_services_bastion_cidr}"]
}

resource "google_compute_firewall" "bastion_allow_outbound" {
  name        = "${var.vpc_name}-allow-outbound-through-bastion"
  network     = "${google_compute_network.main.name}"
  target_tags = ["bastion"]

  allow {
    protocol = "all"
  }

  source_ranges = ["${google_compute_subnetwork.private_subnet.ip_cidr_range}"]
}

resource "google_compute_route" "outbound_through_bastion" {
  name                   = "${var.vpc_name}-outbound-through-bastion"
  dest_range             = "0.0.0.0/0"
  network                = "${google_compute_network.main.name}"
  priority               = "1000"
  next_hop_instance      = "${google_compute_instance.bastion.name}"
  next_hop_instance_zone = "${google_compute_instance.bastion.zone}"
  tags                   = ["private-subnet"]
}
