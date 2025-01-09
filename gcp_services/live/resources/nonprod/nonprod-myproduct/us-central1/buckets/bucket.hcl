locals {
  account_vars   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars    = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  project_id     = local.account_vars.locals.project_id
  environment    = local.account_vars.locals.environment
  env_short_name = local.account_vars.locals.env_short_name
  default_tags   = local.account_vars.locals.default_tags
  bucket_name    = "${basename(get_terragrunt_dir())}"
}

terraform {
  source = "tfr:///terraform-google-modules/cloud-storage/google//modules/simple_bucket?version=9.0.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  location                 = "us"
  name                    = local.bucket_name
  storage_class            = "MULTI_REGIONAL"
  bucket_policy_only       = true
  project_id               = local.project_id
  public_access_prevention = "inherited"
  labels                   = local.default_tags

  #iam_members = [
  #  {
  #    role   = "roles/storage.objectViewer"
  #    member = "allUsers"
  #  },
  #]

  soft_delete_policy = {}

  #lifecycle_rules = [{
  #  action = {
  #    type = "Delete"
  #  }
  #  condition = {
  #    age = 365
  #  }
  #}]

  versioning = true

}
