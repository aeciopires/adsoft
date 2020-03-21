resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.subnet_name}-${random_id.random_suffix.hex}"
  ip_cidr_range            = var.subnet_cidr
  network                  = var.vpc_name
  region                   = var.region
  private_ip_google_access = "true"

  dynamic "secondary_ip_range" {
    for_each = var.range_services
    content {
      range_name    = "${secondary_ip_range.value["range_name"]}-${var.region}"
      ip_cidr_range = secondary_ip_range.value["ip_cidr_range"]
    }
  }
}
