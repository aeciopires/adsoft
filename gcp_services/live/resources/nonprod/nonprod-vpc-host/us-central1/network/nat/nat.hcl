locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.region
  project_id   = local.account_vars.locals.project_id
  nat_name     = "${basename(get_terragrunt_dir())}"
}

terraform {
  source = "tfr:///terraform-google-modules/cloud-nat/google?version=5.3.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name          = local.nat_name
  project_id    = local.project_id
  region        = local.region
  network       = ""
  create_router = false
  router        = ""
  subnetworks   = []

  # Defaults to ALL_SUBNETWORKS_ALL_IP_RANGES. How NAT should be configured per Subnetwork.
  # Valid values include: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS. Changing this forces a new NAT to be created.
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  # List of self_links of external IPs.
  # Changing this forces a new NAT to be created.
  # Value of `nat_ip_allocate_option` is inferred based on nat_ips.
  # If present set to MANUAL_ONLY, otherwise AUTO_ONLY.
  nat_ips = []

  enable_dynamic_port_allocation      = false
  enable_endpoint_independent_mapping = false
  min_ports_per_vm                    = "64"
  icmp_idle_timeout_sec               = "30"
  tcp_established_idle_timeout_sec    = "1200"
  tcp_time_wait_timeout_sec           = "120"
  tcp_transitory_idle_timeout_sec     = "30"
  udp_idle_timeout_sec                = "30"
  max_ports_per_vm                    = null
  log_config_enable                   = true
  log_config_filter                   = "ERRORS_ONLY"
}
