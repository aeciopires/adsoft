include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "keypair" {
  path   = find_in_parent_folders("keypair.hcl")
  expose = true
}

locals {
  customer_vars      = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  public_key_content = local.customer_vars.locals.public_key_content
  customer_tags      = local.customer_vars.locals.customer_tags
}

inputs = {
  public_key = local.public_key_content
  tags       = merge(
    local.customer_tags,
  )
}
