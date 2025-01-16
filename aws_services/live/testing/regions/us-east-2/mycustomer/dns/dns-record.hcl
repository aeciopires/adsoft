locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  dns_zone_id      = local.environment_vars.locals.dns_zone_id
  dns_domain_name  = local.environment_vars.locals.dns_domain_name
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///terraform-aws-modules/route53/aws//modules/records//?version=4.1.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  create              = true
  zone_id             = local.dns_zone_id
  zone_name           = local.dns_domain_name
  records_jsonencoded = jsonencode([
    {
      name    = "CHANGE_HERE"
      type    = "CHANGE_HERE"
      ttl     = 60
      records = [
        "CHANGE_HERE"
      ]
    },
  ])
}
