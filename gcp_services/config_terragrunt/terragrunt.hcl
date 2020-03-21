# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# Configure Terragrunt to automatically store tfstate files in GCS bucket
remote_state {
  backend = "gcs"

  config = {
    project         = "adsoft-gcp-services"
    location        = "us-east1"
    bucket          = "adsoft-states-remote-terragrunt"
    credentials     = "${get_env("HOME", "")}/gcp-service-accounts/service-account_adsoft-gcp-services.json"
    prefix          = "${path_relative_to_include()}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

locals {
  default_yaml_path = find_in_parent_folders("empty.yaml")
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
# Configure Terragrunt to use common vars encoded as yaml to help you keep often-repeated variables (e.g., account ID)
# DRY. We use yamldecode to merge the maps into the inputs, as opposed to using varfiles due to a restriction in
# Terraform >=0.12 that all vars must be defined as variable blocks in modules. Terragrunt inputs are not affected by
# this restriction.
yamldecode(
  file(find_in_parent_folders("project.yaml", local.default_yaml_path)),
),
yamldecode(
  file(find_in_parent_folders("region.yaml", local.default_yaml_path)),
),
)
