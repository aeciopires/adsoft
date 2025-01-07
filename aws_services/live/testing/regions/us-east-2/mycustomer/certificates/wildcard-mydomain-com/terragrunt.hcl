include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "certificate" {
  path   = find_in_parent_folders("certificate.hcl")
  expose = true
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  dns_zone_id      = local.environment_vars.locals.dns_zone_id
  dns_domain_name  = local.environment_vars.locals.dns_domain_name
  customer_tags    = local.customer_vars.locals.customer_tags
}

inputs = {
  create_route53_records    = false
  dns_ttl                   = 60
  validate_certificate      = false
  validation_method         = "DNS"
  domain_name               = local.dns_domain_name
  zone_id                   = local.dns_zone_id
  subject_alternative_names = [
    "*.${local.dns_domain_name}",
    "app.subdomain.${local.dns_domain_name}",
  ]

  wait_for_validation = false
  tags                = merge(
    local.customer_tags,
  )
}
