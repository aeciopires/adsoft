locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  environment      = local.environment_vars.locals.environment_name
  region           = local.region_vars.locals.region
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///terraform-aws-modules/eks/aws//?version=20.31.6"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  cluster_name    = ""
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {}

  vpc_id     = ""
  subnet_ids = []

  tags = {}
}
