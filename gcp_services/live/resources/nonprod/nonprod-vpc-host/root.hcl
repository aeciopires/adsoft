locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "i-dont-exist.hcl"),
    {
      locals = {
        region = "us-central1"
      }
  })

  # Extract the variables we need for easy access
  project_id   = local.account_vars.locals.project_id
  region       = local.region_vars.locals.region
  environment  = local.account_vars.locals.environment
  default_tags = local.account_vars.locals.default_tags
}

remote_state {
  backend = "gcs"

  config = {
    project           = local.project_id
    location          = local.region
    bucket            = "terragrunt-remote-state-${local.project_id}"
    prefix            = "${local.environment}/${path_relative_to_include()}/terraform.tfstate"
    gcs_bucket_labels = local.default_tags
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

terraform {
  # Force Terraform to keep trying to acquire a lock for
  # up to 30 minutes if someone else already has the lock
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=30m"]
  }
}

# Generate an GCP provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
# Providers config
provider "google" {
  project = "${local.project_id}"
  region  = "${local.region}"
  zone    = "${local.region}-a"
}

provider "google-beta" {
  project = "${local.project_id}"
  region  = "${local.region}"
  zone    = "${local.region}-a"
}
EOF
}
