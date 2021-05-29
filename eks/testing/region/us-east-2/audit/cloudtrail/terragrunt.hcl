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
}

dependency "s3" {
  config_path = "../s3/"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/cloudposse/terraform-aws-cloudtrail.git?ref=0.20.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  
  namespace                     = "myS3"
  stage                         = local.environment
  name                          = "audit"
  enable_logging                = true
  enable_log_file_validation    = false
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false
  s3_bucket_name                = dependency.s3.outputs.bucket_id

  tags = {
    "Terraform"   = "true"
    "environment" = "${local.environment}"
    "Scost"       = "${local.scost}"
    "monitoring"  = "${local.monitoring}"
  }
}
