locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.region
  project_id   = local.account_vars.locals.project_id
  default_tags = local.account_vars.locals.default_tags
  ip_name      = "${basename(get_terragrunt_dir())}"
}

terraform {
  source = "tfr:///terraform-google-modules/address/google?version=4.1.0"
}

inputs = {

  names  = [
    local.ip_name
  ]
  project_id   = local.project_id
  region       = local.region
  global       = false
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
  network_tier = "PREMIUM"
  labels       = local.default_tags
}
