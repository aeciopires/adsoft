//# ---------------------------------------------------------------------------------------------------------------------
//# For storage *.tfstate in remote bucket s3
//# ---------------------------------------------------------------------------------------------------------------------

locals {
  environment_vars        = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment             = local.environment_vars.locals.environment
  region_bucket           = local.environment_vars.locals.region_bucket
  bucket_remote_tfstate   = local.environment_vars.locals.bucket_remote_tfstate
  dynamodb_remote_tfstate = local.environment_vars.locals.dynamodb_remote_tfstate
  profile_remote_tfstate  = local.environment_vars.locals.profile_remote_tfstate
}

# Configure Terragrunt to automatically store tfstate files in S3 bucket
remote_state {
  backend = "s3"

  config = {
    bucket                  = "${local.bucket_remote_tfstate}"
    dynamodb_table          = "${local.dynamodb_remote_tfstate}"
    key                     = "${local.environment}/${path_relative_to_include()}/terraform.tfstate"
    region                  = "${local.region_bucket}"
    encrypt                 = true
    profile                 = "${local.profile_remote_tfstate}"
    shared_credentials_file = "${get_env("HOME", "")}/.aws/credentials"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
# Providers config
provider "aws" {
  region                  = "${local.region_bucket}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${local.profile_remote_tfstate}"
}

#terraform {
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = ">= 3.42.0"
#    }
#    randon = {
#      source  = "hashicorp/aws"
#      version = ">= 3.1.0"
#    }
#    template = {
#      source  = "hashicorp/aws"
#      version = ">= 2.2.0"
#    }
#    null = {
#      source  = "hashicorp/aws"
#      version = ">= 3.1.0"
#    }
#    kubernetes = {
#      source  = "hashicorp/aws"
#      version = ">= 2.2.0"
#    }
#    local = {
#      source  = "hashicorp/aws"
#      version = ">= 3.1.0"
#    }
#  }
#}
EOF
}
