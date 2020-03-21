resource "google_compute_router" "cloud_router" {
  name    = "${var.cloud_router}-${random_id.random_suffix.hex}"
  network = var.vpc_name
  bgp {
    asn               = 64514
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
    advertised_ip_ranges {
      range = google_compute_subnetwork.subnet.ip_cidr_range
    }
  }
}
