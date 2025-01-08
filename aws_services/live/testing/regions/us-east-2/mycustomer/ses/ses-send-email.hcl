locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  dns_zone_id      = local.environment_vars.locals.dns_zone_id
  ses_name         = "${basename(get_terragrunt_dir())}"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///cloudposse/ses/aws//?version=0.25.1"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  enabled                        = true
  name                           = local.ses_name
  ses_user_enabled               = true
  create_spf_record              = false
  custom_from_dns_record_enabled = false
  custom_from_subdomain          = []
  domain                         = ""
  environment                    = ""
  iam_allowed_resources          = []
  iam_permissions                = [
    "ses:SendRawEmail"
  ]
  zone_id                        = local.dns_zone_id
  verify_domain                  = true
  verify_dkim                    = true
  tags                           = {}
}