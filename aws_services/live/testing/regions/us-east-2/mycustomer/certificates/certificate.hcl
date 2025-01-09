locals {}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///terraform-aws-modules/acm/aws//?version=5.1.1"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  create_certificate        = true
  create_route53_records    = false
  dns_ttl                   = 60
  validate_certificate      = false
  validation_method         = "DNS"
  domain_name               = ""
  zone_id                   = ""
  subject_alternative_names = []
  wait_for_validation       = false
  tags                      = {}
}