locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  project_id   = local.account_vars.locals.project_id
}

terraform {
  source = "tfr:///terraform-google-modules/network/google//modules/firewall-rules?version=10.0.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  project_id    = local.project_id
  network_name  = ""
  ingress_rules = []
  egress_rules  = []
}
