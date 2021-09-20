# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  environment_vars    = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars         = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment         = local.environment_vars.locals.environment
  scost               = local.environment_vars.locals.scost
  cidr                = local.environment_vars.locals.cidr
  azs                 = local.region_vars.locals.azs
  public_subnets      = local.region_vars.locals.public_subnets
  private_subnets     = local.region_vars.locals.private_subnets
  vpc_tags            = local.region_vars.locals.vpc_tags
  public_subnet_tags  = local.region_vars.locals.public_subnet_tags
  private_subnet_tags = local.region_vars.locals.private_subnet_tags
  customer_id         = local.environment_vars.locals.customer_id
  customer_name       = local.environment_vars.locals.customer_name
  cluster1_name       = "mycluster-eks-testing"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//?ref=v3.7.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name                   = "${local.customer_id}-dataplane"
  cidr                   = "${local.cidr}"
  azs                    = "${local.azs}"
  public_subnets         = "${local.public_subnets}"
  private_subnets        = "${local.private_subnets}"
  vpc_tags               = "${local.vpc_tags}"
  public_subnet_tags     = "${local.public_subnet_tags}"
  private_subnet_tags    = "${local.private_subnet_tags}"
  enable_dns_support     = true
  enable_dns_hostnames   = true
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  tags = {
    "Terraform"                                      = "true"
    "environment"                                    = "${local.environment}"
    "Scost"                                          = "${local.customer_id}"
    "Customer"                                       = "${local.customer_name}"
    "customer_id"                                    = "${local.customer_id}"
    "kubernetes.io/cluster/${local.cluster1_name}"   = "shared"
  }
}
