locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.region
  project_id   = local.account_vars.locals.project_id
  router_name  = "${basename(get_terragrunt_dir())}"
}

terraform {
  source = "tfr:///terraform-google-modules/cloud-router/google?version=6.2.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name    = local.router_name
  project = local.project_id
  region  = local.region
  network = ""
  bgp     = null
}
