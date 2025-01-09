include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "nat" {
  path   = find_in_parent_folders("nat.hcl")
  expose = true
}

locals {
  region_vars          = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region               = local.region_vars.locals.region
  dependency_base_path = "${dirname(find_in_parent_folders())}/${local.region}"
}

# When applying this terragrunt config in an `run-all` command, make sure the modules below are handled first.
dependencies {
  paths = [
    "${local.dependency_base_path}/network/vpc/vpc-nonprod-shared",
    "${local.dependency_base_path}/network/routers/router-nonprod-shared",
    "${local.dependency_base_path}/network/subnets/shared-services1",
    "${local.dependency_base_path}/network/static-ips/public-ips/nonprod-external-ip-nat"
  ]
}

# When applying this terragrunt config in an `run-all` command, make sure the modules below are handled first.
dependency "vpc" {
  config_path = "${local.dependency_base_path}/network/vpc/vpc-nonprod-shared"
}

dependency "router" {
  config_path = "${local.dependency_base_path}/network/routers/router-nonprod-shared"
}

dependency "subnet-shared-services1" {
  config_path = "${local.dependency_base_path}/network/subnets/shared-services1"
}

dependency "nat-static-ip" {
  config_path = "${local.dependency_base_path}/network/static-ips/public-ips/nonprod-external-ip-nat"
}

inputs = {
  create_router = false
  router        = dependency.router.outputs.router.name

  # List of self_links of external IPs.
  # Changing this forces a new NAT to be created.
  # Value of `nat_ip_allocate_option` is inferred based on nat_ips.
  # If present set to MANUAL_ONLY, otherwise AUTO_ONLY.
  nat_ips = [
    dependency.nat-static-ip.outputs.self_links[0]
  ]

  # Defaults to ALL_SUBNETWORKS_ALL_IP_RANGES. How NAT should be configured per Subnetwork.
  # Valid values include: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS. Changing this forces a new NAT to be created.
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetworks                        = [
    {
      name                     = dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].self_link
      source_ip_ranges_to_nat  = ["LIST_OF_SECONDARY_IP_RANGES", "PRIMARY_IP_RANGE"]
      secondary_ip_range_names = [
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[0].range_name,
        dependency.subnet-shared-services1.outputs.subnets["${local.region}/shared-services1"].secondary_ip_range[1].range_name
      ]
    },
  ]
}
