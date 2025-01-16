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
  dns_zone_id      = local.environment_vars.locals.dns_zone_id
  dns_domain_name  = local.environment_vars.locals.dns_domain_name
}

# When applying this terragrunt config in an `run-all` command, make sure the modules below are handled first.
dependencies {
  paths = [
    "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/certificates/wildcard-mydomain-com/",
  ]
}

dependency "certificate" {
  config_path = "${get_repo_root()}/aws_services/live/${local.environment}/regions/${local.region}/mycustomer/certificates/wildcard-mydomain-com/"
}

inputs = {

  create              = true
  zone_id             = local.dns_zone_id
  zone_name           = local.dns_domain_name
  records_jsonencoded = jsonencode([
    {
      #name    = dependency.certificate.outputs.validation_domains.0.resource_record_name
      name    = "_f658d77fdcdc5fce9f4d5451284b4198"
      type    = "CNAME"
      ttl     = 60
      records = [
        dependency.certificate.outputs.validation_domains.0.resource_record_value
      ]
    }
  ])
}
