include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "subnet" {
  path   = find_in_parent_folders("subnet.hcl")
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
    "${local.dependency_base_path}/network/vpc/vpc-nonprod-shared"
  ]
}

# Extracting the output from another terragrunt.hcl
dependency "vpc" {
  config_path = "${local.dependency_base_path}/network/vpc/vpc-nonprod-shared"
}

inputs = {

  network_name = dependency.vpc.outputs.network_name
  subnets      = [
    {
      subnet_name               = "shared-services1"
      subnet_ip                 = "10.0.0.0/16"
      subnet_region             = local.region
      # Enable to allow privante instances access GCP Services
      subnet_private_access     = true
      # Enable only for troubleshooting
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
  ]
  secondary_ranges = {
    shared-services1 = [
      {
        range_name    = "gke-nonprod-pods"
        ip_cidr_range = "10.10.0.0/16"
      },
      {
        range_name    = "gke-nonprod-services"
        ip_cidr_range = "10.20.0.0/16"
      },
    ]
  }
}
