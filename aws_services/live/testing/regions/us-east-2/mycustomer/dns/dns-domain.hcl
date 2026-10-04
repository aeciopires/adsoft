locals {}

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
  create      = true
  create_zone = true
  name        = ""
  comment     = ""
  records     = {}
  tags        = {}
}
