# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "i-dont-exist.hcl"),
    {
      locals = {
        region = "us-east-1"
      }
  })

  # Extract the variables we need for easy access
  aws_profile           = local.environment_vars.locals.aws_profile
  region_bucket         = local.environment_vars.locals.region_bucket
  bucket_remote_tfstate = local.environment_vars.locals.bucket_remote_tfstate
  default_tags          = local.environment_vars.locals.default_tags
  region                = local.region_vars.locals.region
}

# Configure Terragrunt to store tfstate files in S3 bucket.
# The state lock uses a lock file in the S3 bucket (use_lockfile). The DynamoDB table for state locking
# (dynamodb_table) is deprecated in the S3 backend of Terraform.
# Since Terragrunt 1.0 the S3 bucket is created only if the flag --backend-bootstrap is used
# (or with the command 'terragrunt backend bootstrap').
# https://docs.terragrunt.com/features/units/state-backend/
# https://developer.hashicorp.com/terraform/language/backend/s3
remote_state {
  backend = "s3"

  config = {
    bucket       = local.bucket_remote_tfstate
    use_lockfile = true
    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = local.region_bucket
    encrypt      = true
    profile      = local.aws_profile
    s3_bucket_tags = merge(
      local.default_tags,
    )
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # Force Terraform to keep trying to acquire a lock for
  # up to 30 minutes if someone else already has the lock
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=30m"]
  }
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
# Providers config
provider "aws" {
  profile = "${local.aws_profile}"
  region  = "${local.region}"
}

EOF
}
