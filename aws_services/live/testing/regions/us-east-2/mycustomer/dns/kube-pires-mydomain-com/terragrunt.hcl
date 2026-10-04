include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "dns-record" {
  path   = find_in_parent_folders("dns-record.hcl")
  expose = true
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  region           = local.region_vars.locals.region
  environment      = local.environment_vars.locals.environment_name
  dns_domain_name  = local.environment_vars.locals.dns_domain_name
  customer_id      = local.customer_vars.locals.customer_id
}

# When applying this terragrunt config with the `run --all` command, make sure the modules below are handled first.
dependencies {
  paths = [
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/loadbalancer/${local.customer_id}-apps/"
  ]
}

dependency "loadbalancer" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/loadbalancer/${local.customer_id}-apps/"
}

inputs = {
  create      = true
  create_zone = false
  name        = local.dns_domain_name

  records = {
    kube-pires = {
      type = "CNAME"
      ttl  = 60
      records = [
        dependency.loadbalancer.outputs.dns_name
      ]
    }
  }
}
