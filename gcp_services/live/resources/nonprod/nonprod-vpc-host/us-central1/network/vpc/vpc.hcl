locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  project_id   = local.account_vars.locals.project_id
  vpc_name     = "${basename(get_terragrunt_dir())}"
}

terraform {
  source = "tfr:///terraform-google-modules/network/google//modules/vpc?version=10.0.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  project_id                             = local.project_id
  network_name                           = local.vpc_name
  auto_create_subnetworks                = false
  routing_mode                           = "GLOBAL"
  shared_vpc_host                        = false
  enable_ipv6_ula                        = false
  delete_default_internet_gateway_routes = false

  # The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). 
  # Recommended values: 1460 (default for historic reasons),
  #                     1500 (Internet default), or
  #                     8896 (for Jumbo packets).
  # Allowed are all values in the range 1300 to 8896, inclusively.
  mtu = 1460
}
