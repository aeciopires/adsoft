include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "router" {
  path   = find_in_parent_folders("router.hcl")
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

# When applying this terragrunt config in an `run-all` command, make sure the modules below are handled first.
dependency "vpc" {
  config_path = "${local.dependency_base_path}/network/vpc/vpc-nonprod-shared"
}

inputs = {
  network = dependency.vpc.outputs.network_name
  bgp     = null
}
