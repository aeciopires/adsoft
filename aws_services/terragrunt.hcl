remote_state {
  backend = "s3"
  config  = {
    bucket                  = "adsoft-s3"
    key                     = "${path_relative_to_include()}/terraform.tfstate"
    region                  = "us-east-2"
    encrypt                 = true
    dynamodb_table          = "terraform"
    shared_credentials_file = "~/.aws/credentials"
  }
}

terraform{
  extra_arguments "prod_vars" {
    commands = ["plan", "apply"]

    arguments = [
      "-var-file=terraform_prod.tfvars"
    ]
  }
}