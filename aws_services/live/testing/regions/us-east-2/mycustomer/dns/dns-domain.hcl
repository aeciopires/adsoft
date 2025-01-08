locals {}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///terraform-aws-modules/route53/aws//modules/zones//?version=4.1.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  create = true
  zones  = {}
  tags   = {}
}