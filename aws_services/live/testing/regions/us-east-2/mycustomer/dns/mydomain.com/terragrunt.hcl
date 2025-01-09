include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "dns-domain" {
  path   = find_in_parent_folders("dns-domain.hcl")
  expose = true
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  dns_domain_name  = local.environment_vars.locals.dns_domain_name
  customer_tags    = local.customer_vars.locals.customer_tags
}

inputs = {
  zones = {
    "${local.dns_domain_name}" = {
      comment = "${local.dns_domain_name} (production)"
      tags = {
        Name = "${local.dns_domain_name}"
      }
    }
  }
  tags = local.customer_tags
}
