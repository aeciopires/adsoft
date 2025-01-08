include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "kms" {
  path   = find_in_parent_folders("kms.hcl")
  expose = true
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  environment      = local.environment_vars.locals.environment_name
  customer_name    = local.customer_vars.locals.customer_name
  customer_tags    = local.customer_vars.locals.customer_tags
}

inputs = {
  create                  = true
  description             = "General ${local.customer_name}-${local.environment} encryption key"
  aliases                 = ["alias/${local.customer_name}-${local.environment}"]
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  enable_key_rotation     = false
  is_enabled              = true
  multi_region            = false
  tags                    = merge(
    local.customer_tags,
  )
}
