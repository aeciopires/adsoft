# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  environment_vars       = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars            = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment            = local.environment_vars.locals.environment
  region_bucket          = local.environment_vars.locals.region_bucket
  scost                  = local.environment_vars.locals.scost
  monitoring             = local.environment_vars.locals.monitoring
  profile_remote_tfstate = local.environment_vars.locals.profile_remote_tfstate
  region                 = local.region_vars.locals.region
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/cloudposse/terraform-aws-cloudtrail-s3-bucket.git?ref=tags/0.17.2"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  namespace       = "mys3"
  stage           = local.environment
  name            = "audit"
  region          = local.region_bucket
  force_destroy   = false
  expiration_days = "365"

  tags = {
    "Terraform"    = "true"
    "allow_public" = "false"
    "environment"  = "${local.environment}"
    "Scost"        = "${local.scost}"
    "monitoring"   = "${local.monitoring}"
  }
}
