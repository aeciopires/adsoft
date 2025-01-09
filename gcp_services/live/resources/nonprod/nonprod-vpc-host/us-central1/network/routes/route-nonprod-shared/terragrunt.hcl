include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "route" {
  path   = find_in_parent_folders("route.hcl")
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
  network_name = dependency.vpc.outputs.network_name
  routes       = [
    {
      name              = "route-nonprod-shared-egress-internet"
      description       = "Route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      next_hop_internet = "true"
    },
    # Only example, if you need to route through a proxy instance
    #{
    #  name                   = "app-proxy"
    #  description            = "route through proxy to reach app"
    #  destination_range      = "10.50.10.0/24"
    #  tags                   = "app-proxy"
    #  next_hop_instance      = "app-proxy-instance"
    #  next_hop_instance_zone = "us-west1-a"
    #},
  ]
}
