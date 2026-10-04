locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  dns_domain_name  = local.environment_vars.locals.dns_domain_name
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  # Since v6.0.0 the module creates the zone and the records (the submodules 'zones' and 'records' were removed).
  # https://github.com/terraform-aws-modules/terraform-aws-route53
  source = "tfr:///terraform-aws-modules/route53/aws//?version=6.5.1"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  create = true
  # Lookup an existing public zone by name instead of creating it
  create_zone = false
  name        = local.dns_domain_name

  # The key of the map is used as the subdomain name, unless 'name' or 'full_name' is set
  records = {
    CHANGE_HERE = {
      type = "CHANGE_HERE"
      ttl  = 60
      records = [
        "CHANGE_HERE"
      ]
    }
  }
}
