locals {
  account_vars   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars    = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_short_name = local.account_vars.locals.env_short_name
  default_tags   = local.account_vars.locals.default_tags
  project_id     = local.account_vars.locals.project_id
  region         = local.region_vars.locals.region
  repository_id  = "${basename(get_terragrunt_dir())}"
}

terraform {
  source = "tfr:///GoogleCloudPlatform/artifact-registry/google?version=0.3.0"
}

inputs = {

  project_id    = local.project_id
  location      = local.region
  # Page with all supported formats:
  # https://cloud.google.com/artifact-registry/docs/supported-formats
  format        = "DOCKER"
  repository_id = local.repository_id
  labels        = local.default_tags
  # The mode configures the repository to serve artifacts from different sources.
  # Default value is STANDARD_REPOSITORY. 
  # Possible values are: STANDARD_REPOSITORY, VIRTUAL_REPOSITORY, REMOTE_REPOSITORY
  mode          = "STANDARD_REPOSITORY"
}
