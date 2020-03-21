resource "random_id" "random_suffix" {
  byte_length = 2
}

resource "google_compute_address" "address" {
  count  = var.number_of_nat_address
  name   = "${var.nat_name}-${count.index}-${random_id.random_suffix.hex}"
  region = var.region
}

resource "google_compute_router_nat" "nat_general" {
  name                               = "${var.cloud_nat}-${random_id.random_suffix.hex}"
  router                             = "${var.cloud_router}-${random_id.random_suffix.hex}"
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.address.*.self_link
  min_ports_per_vm                   = var.min_ports_per_vm
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"

  depends_on = [google_compute_router.cloud_router]
}
