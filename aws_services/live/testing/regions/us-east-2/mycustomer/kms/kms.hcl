locals {}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # Added double slash terragrunt: https://ftclausen.github.io/dev/infra/terraform-solving-the-double-slash-mystery/
  source = "tfr:///terraform-aws-modules/kms/aws//?version=3.1.1"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  create                  = true
  description             = ""
  aliases                 = []
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  enable_key_rotation     = false
  is_enabled              = true
  multi_region            = false
  tags                    = {}
}
