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
  region           = local.region_vars.locals.region
  environment      = local.environment_vars.locals.environment_name
  dns_domain_name  = local.environment_vars.locals.dns_domain_name
}

# When applying this terragrunt config with the `run --all` command, make sure the modules below are handled first.
dependencies {
  paths = [
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/certificates/wildcard-mydomain-com/",
  ]
}

dependency "certificate" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/certificates/wildcard-mydomain-com/"
}

inputs = {
  create      = true
  create_zone = false
  name        = local.dns_domain_name

  records = {
    acm-validation = {
      # Full name of the record returned by ACM, e.g. _abc123.mydomain.com.
      full_name = dependency.certificate.outputs.validation_domains[0].resource_record_name
      type      = "CNAME"
      ttl       = 60
      records = [
        dependency.certificate.outputs.validation_domains[0].resource_record_value
      ]
    }
  }
}
