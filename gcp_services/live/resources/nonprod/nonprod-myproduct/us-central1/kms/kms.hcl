locals {
  account_vars   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars    = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region         = local.region_vars.locals.region
  env_short_name = local.account_vars.locals.env_short_name
  default_tags   = local.account_vars.locals.default_tags
  project_id     = local.account_vars.locals.project_id
  key_name       = "${local.env_short_name}-${basename(get_terragrunt_dir())}"
}

terraform {
  source = "tfr:///terraform-google-modules/kms/google?version=3.2.0"
}

inputs = {

  project_id           = local.project_id
  location             = local.region
  keyring              = local.key_name
  prevent_destroy      = true
  purpose              = "ENCRYPT_DECRYPT"
  key_algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
  keys                 = ["sops", "vault"]
  labels               = local.default_tags
  key_protection_level = "SOFTWARE"
  key_rotation_period  = null
  owners               = []
  set_owners_for       = []
  set_decrypters_for   = []
  set_decrypters_for   = []
}
