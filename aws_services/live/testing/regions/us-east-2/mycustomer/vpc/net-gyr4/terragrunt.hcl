include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "vpc" {
  path   = find_in_parent_folders("vpc.hcl")
  expose = true
}

locals {
  region_vars         = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars       = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  az_id_list          = local.region_vars.locals.az_id_list
  customer_tags       = local.customer_vars.locals.customer_tags
  cidr                = local.customer_vars.locals.cidr
  public_subnets      = local.customer_vars.locals.public_subnets
  private_subnets     = local.customer_vars.locals.private_subnets
  public_subnet_tags  = local.customer_vars.locals.public_subnet_tags
  private_subnet_tags = local.customer_vars.locals.private_subnet_tags
}

inputs = {
  cidr                = local.cidr
  azs                 = local.az_id_list
  public_subnets      = local.public_subnets
  private_subnets     = local.private_subnets
  public_subnet_tags  = local.public_subnet_tags
  private_subnet_tags = local.private_subnet_tags
  vpc_tags            = local.customer_tags
  vpc_endpoint_tags   = merge(
    local.customer_tags,
    {
      Name = include.vpc.inputs.name
    }
  )

  tags = merge(
    local.customer_tags,
  )
}
