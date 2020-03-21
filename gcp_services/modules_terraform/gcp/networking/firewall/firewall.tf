# INGRESS
resource "google_compute_firewall" "intra_subnet_ingress" {
  count          = length(var.testing_project1_cluster_name)
  provider       = google
  name           = "intra-subnet-ingress-${data.google_container_cluster.testing_project1[count.index].name}"
  network        = var.network_services
  description    = "Allow ingress traffic intra services subnet"
  enable_logging = "true"
  priority       = 900
  direction      = "INGRESS"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = flatten([
    var.subnet_cidr[count.index],
    data.google_container_cluster.testing_project1[count.index].services_ipv4_cidr,
    data.google_container_cluster.testing_project1[count.index].cluster_ipv4_cidr,
    data.google_container_cluster.testing_project1[count.index].private_cluster_config[0].master_ipv4_cidr_block
  ])
}

#Allow access to public
resource "google_compute_firewall" "allow-access-public" {
  provider       = google
  name           = "allow-access-public"
  network        = var.network_services
  enable_logging = "true"
  description    = "Allow access public"

  allow {
    protocol = "tcp"
    ports    = ["80", "443",]
  }

  allow {
    protocol = "icmp"
  }

  target_tags = ["access-public"]

  source_ranges = var.list_valid_ip
}

#Allow outbound traffic to external ports
resource "google_compute_firewall" "allow-to-external-services" {
  provider       = google
  name           = "allow-to-external-services"
  network        = var.network_services
  description    = "Allow egress traffic to external services"
  enable_logging = "true"
  priority       = 900
  direction      = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "53",]
  }

  allow {
    protocol = "udp"
    ports    = ["53", "123"]
  }

  allow {
    protocol = "icmp"
  }
}