terraform {
  backend "s3" {}
}

provider "google" {
  region      = "${var.region}"
  project     = "${var.project_name}"
  credentials = "${file("${var.credentials_file_path}")}"
  version     = "~> 0.1.3"
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

resource "google_compute_address" "nat_ip" {
  name = "${var.vpc_name}-nat-b-address"
}

resource "google_compute_instance" "nat" {
  name           = "${var.vpc_name}-nat-b"
  machine_type   = "${var.nat_machine_type}"
  zone           = "${var.region_zone}"
  can_ip_forward = "true"

  tags = ["nat"]

  boot_disk {
    initialize_params {
      image = "${var.nat_image}"
      size  = "10"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.public_subnet.name}"
    address    = "${var.nat_internal_ip}"

    access_config {
      nat_ip = "${google_compute_address.nat_ip.address}"
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

resource "google_compute_firewall" "nat_allow_outbound" {
  name        = "${var.vpc_name}-allow-outbound-through-nat"
  network     = "${google_compute_network.main.name}"
  target_tags = ["nat"]

  allow {
    protocol = "all"
  }

  source_ranges = ["${google_compute_subnetwork.private_subnet.ip_cidr_range}"]
}

resource "google_compute_route" "outbound_through_nat" {
  name                   = "${var.vpc_name}-outbound-through-nat"
  dest_range             = "0.0.0.0/0"
  network                = "${google_compute_network.main.name}"
  priority               = "1000"
  next_hop_instance      = "${google_compute_instance.nat.name}"
  next_hop_instance_zone = "${google_compute_instance.nat.zone}"
  tags                   = ["private-subnet"]
}
