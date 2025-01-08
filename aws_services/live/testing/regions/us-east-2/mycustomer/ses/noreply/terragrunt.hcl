include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "ses-send-email" {
  path   = find_in_parent_folders("ses-send-email.hcl")
  expose = true
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region           = local.region_vars.locals.region
  environment      = local.environment_vars.locals.environment_name
  dns_zone_id      = local.environment_vars.locals.dns_zone_id
  dns_domain_name  = local.environment_vars.locals.dns_domain_name
  customer_tags    = local.customer_vars.locals.customer_tags
}

inputs = {
  create_spf_record              = true
  custom_from_dns_record_enabled = true
  custom_from_subdomain          = []
  domain                         = local.dns_domain_name
  environment                    = local.environment
  iam_allowed_resources          = []
  iam_permissions                = [
    "ses:SendRawEmail"
  ]
  zone_id                        = local.dns_zone_id
  verify_domain                  = true
  verify_dkim                    = true
  tags                           = local.customer_tags
}
