# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  environment_vars       = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars            = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment            = local.environment_vars.locals.environment
  scost                  = local.environment_vars.locals.scost
  monitoring             = local.environment_vars.locals.monitoring
  profile_remote_tfstate = local.environment_vars.locals.profile_remote_tfstate
  region                 = local.region_vars.locals.region
  key_name               = local.region_vars.locals.key_name
  public_key_content     = local.region_vars.locals.public_key_content
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-key-pair.git//?ref=v1.0.1"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  create_key_pair = true
  key_name        = local.key_name
  public_key      = local.public_key_content

  tags = {
    "Terraform"   = "true"
    "environment" = "${local.environment}"
    "Scost"       = "${local.scost}"
    "monitoring"  = "${local.monitoring}"
  }
}
