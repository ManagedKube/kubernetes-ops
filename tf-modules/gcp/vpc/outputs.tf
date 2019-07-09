output "network_name" {
  value = "${google_compute_network.main.name}"
}

output "network" {
  value = "${google_compute_network.main.self_link}"
}

output "private_subnet_name" {
  value = "${google_compute_subnetwork.private_subnet.name}"
}

output "public_subnet_name" {
  value = "${google_compute_subnetwork.public_subnet.name}"
}

output "private_subnet_cidr" {
  value = "${google_compute_subnetwork.private_subnet.ip_cidr_range}"
}

output "public_subnet_cidr" {
  value = "${google_compute_subnetwork.public_subnet.ip_cidr_range}"
}
