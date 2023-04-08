# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment      = local.environment_vars.locals.environment
  profile          = local.environment_vars.locals.profile_remote_tfstate
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "..//policy_module_loadbalancer"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  # General
  profile     = "${local.profile}"
  environment = "${local.environment}"

  name = "aws_lb_controller"
  path = "/"
}
