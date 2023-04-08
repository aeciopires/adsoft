//# ---------------------------------------------------------------------------------------------------------------------
//# TERRAGRUNT CONFIGURATION
//# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
//# remote state, and locking: https://github.com/gruntwork-io/terragrunt
//# ---------------------------------------------------------------------------------------------------------------------

//# ---------------------------------------------------------------------------------------------------------------------
//# GLOBAL PARAMETERS
//# These variables apply to all configurations in this subfolder. These are automatically merged into the child
//# `terragrunt.hcl` config via the include block.
//# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # Force Terraform to keep trying to acquire a lock for
  # up to 30 minutes if someone else already has the lock
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=30m"]
  }
}

